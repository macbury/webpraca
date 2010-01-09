JOB_TYPES = ["zlecenie (konkretna usługa do wykonania)", "poszukiwanie współpracowników / oferta pracy", "wolontariat (praca za reklamy, bannery, itp. lub praca za darmo)", "staż/praktyka"]
JOB_LABELS = ["zlecenie", "etat", "wolontariat", "praktyka"]

JOB_ETAT = 1;

JOB_RANK_VALUES = { 
										:default => 0.3, 
										:price => 0.8, 
										:krs => 0.6, 
										:nip => 0.5, 
										:regon => 0.6, 
										:framework_id => 0.7, 
										:language_id => 0.7,
										:website => 0.4,
										:apply_online => 0.3
									}

class Job < ActiveRecord::Base
	include ActionController::UrlWriter
	xss_terminate
	has_permalink :title
	
	named_scope :active, :conditions => ["((jobs.end_at >= ?) AND (jobs.published = ?))", Date.current, true]
	named_scope :old, :conditions => ["jobs.end_at < ?", Date.current]
	
	named_scope :has_text, lambda { |text| { :conditions => ["((jobs.title ILIKE ?) OR (jobs.description ILIKE ?))", "%#{text}%", "%#{text}%"] } }
	
	validates_presence_of :title, :description, :email, :company_name, :localization_id, :category_id
	
	validates_length_of :title, :within => 3..255
	validates_length_of :description, :within => 10..5000
	validates_inclusion_of :type_id, :in => 0..JOB_TYPES.size-1
	validates_inclusion_of :availability_time, :in => 1..60
	
	validates_numericality_of :price_from, 
			:greater_than => 0, 
			:unless => Proc.new { |j| j.price_from.nil? }
	validates_numericality_of :price_to, 
			:greater_than => 0, 
			:unless => Proc.new { |j| j.price_to.nil? }
	
	validates_format_of :email, :with => /([a-z0-9_.-]+)@([a-z0-9-]+)\.([a-z.]+)/i
	
	validates_format_of :website, :with =>  /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
	
	validates_format_of :regon, 
			:with => /(^$)|(^[0-9]{7,14}$)/
	validates_format_of :nip,
			:with => /(^$)|(^\d{2,3}-\d{2,3}-\d{2,3}-\d{2,3}$)/
	validates_format_of :krs,
			:with => /(^$)|(^\d{10})$/
	
	belongs_to :framework
	belongs_to :localization
	belongs_to :category
	belongs_to :language
	
	has_many :applicants, :dependent => :delete_all
	has_many :visits, 		:dependent => :delete_all
	
	attr_protected :rank, :permalink, :end_at, :token, :published
	attr_accessor  :framework_name, :localization_name
	
	before_create :create_from_name, :generate_token
	before_save   :calculate_rank
	after_create  :send_notification
	
	def self.find_grouped_by_type
		return Job.active.count(:type_id, :group => "type_id")
	end
	
	def send_notification
		JobMailer.deliver_job_posted(self)
	end
	
	def generate_token
		alphanumerics = ('a'..'z').to_a.concat(('A'..'Z').to_a.concat(('0'..'9').to_a))
		salt = alphanumerics.sort_by{rand}.to_s[0..1024]
		
		self.token = Digest::SHA1.hexdigest("--#{salt}--#{self.id}--#{Date.current}--")
		
		generate_token unless Job.find_by_token(self.token).nil?
	end
	
	def calculate_rank
		self.rank = 1.0
		
		self.rank += visits_count * 0.01 unless visits_count.nil?
		
		[:regon, :nip, :krs, :framework_id, :website, :apply_online].each do |attribute|
			val = send(attribute)

			inc = JOB_RANK_VALUES[attribute] || JOB_RANK_VALUES[:default]
			self.rank += inc unless (val.nil? || (val.class == String && val.empty?) || (val.class == TrueClass))
		end
		
		if pay_band?
			self.rank += JOB_RANK_VALUES[:price]
			
			price = price_from || price_to
			
			if price >= 10_000 # ciekawe czy ktoś da tyle :P
				self.rank += 0.8
			elsif price >= 7000
				self.rank += 0.7
			elsif price >= 5000
				self.rank += 0.6
			elsif price >= 3000
				self.rank += 0.3
			elsif price < 2000
				if self.type_id == JOB_ETAT
					self.rank -= 0.6 # bo nikt za grosze nie chce pracować 
				else
					self.rank += 0.3 # chyba że to biedny student
				end
			end
		end
	end
	
	def pay_band?
		((!self.price_from.nil? && self.price_from > 0) || (!self.price_to.nil? && self.price_to > 0))
	end
	
	def create_from_name
		unless (self.framework_name.nil? || self.framework_name.blank?) 
			framework = Framework.name_like(self.framework_name).first
			framework = Framework.create(:name => self.framework_name) if framework.nil?
			
			self.framework = framework
		end
		
		unless (self.localization_name.nil? || self.localization_name.blank?) 
			localization = Localization.name_like(self.localization_name).first
			localization = Localization.create(:name => self.localization_name) if localization.nil?
			
			self.localization = localization
		end
	end
	
	def availability_time
		date = created_at.nil? ? Date.current.to_date : created_at.to_date
		return (read_attribute(:end_at) - date).to_i rescue 14
	end
	
	def availability_time=(val)
		date = created_at.nil? ? Date.current.to_date : created_at.to_date
		write_attribute(:end_at, date+val.to_i.days)
	end
	
	def highlighted?
		self.rank >= 4.75
	end
	
	def publish!
		self.published = true
		save

		tags = [localization.name, category.name, "praca", JOB_LABELS[self.type_id]]
		tags << framework.name unless framework.nil?
		
		MicroFeed.send	:streams => :all,
										:msg => "[#{company_name}] - #{title}",
										:tags => tags,
										:link => seo_job_url(self, :host => "webpraca.net") if Rails.env == "production"

	end
	
	def visited_by(ip)
		visit = visits.find_or_create_by_ip(IPAddr.new(ip).to_i)
		visits_count += 1 if visit.new_record?
		save
	end
	
	def to_param
		permalink
	end
end
