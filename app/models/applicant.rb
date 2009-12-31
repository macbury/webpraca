class Applicant < ActiveRecord::Base
	xss_terminate
	
	has_attached_file :cv,
  									:path => ":rails_root/tmp/attachments/:id.:extension"

	validates_attachment_size :cv, 
										:less_than => 5.megabytes, 
										:if => Proc.new { |a| a.have_attachment? }
	validates_attachment_content_type :cv, 
										:content_type => ['application/pdf', 'application/msword', 'application/zip', 'application/x-rar-compressed', 'text/plain', 'text/rtf'],
										:if => Proc.new { |a| a.have_attachment? }
	
	validates_presence_of :email, :body
	validates_length_of :body, :within => 3..2024
	validates_uniqueness_of :email, :scope => [:job_id]
	validates_format_of :email, :with => Authlogic::Regex.email
	
	belongs_to :job, :counter_cache => true
	attr_protected :job_id, :token
	
	before_create :generate_token
	after_create :send_email
	
	def generate_token
		alphanumerics = ('a'..'z').to_a.concat(('A'..'Z').to_a.concat(('0'..'9').to_a))
		salt = alphanumerics.sort_by{rand}.to_s[0..1024]
		
		self.token = Digest::SHA1.hexdigest("--#{salt}--#{self.id}--#{Date.current}--#{self.job.id}")
		
		generate_token unless Applicant.find_by_token(self.token).nil?
	end
	
	def have_attachment?
		!cv_file_name.nil?
	end
	
	def send_email
		JobMailer.deliver_job_applicant(self)
	end
end
