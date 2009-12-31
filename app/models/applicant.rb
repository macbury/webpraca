class Applicant < ActiveRecord::Base
	xss_terminate
	
	has_attached_file :cv,
										:url  => "/assets/:id.:extension",
  									:path => ":rails_root/public/assets/:id.:extension"

	validates_attachment_size :cv, :less_than => 5.megabytes
	validates_attachment_content_type :cv, :content_type => ['application/pdf', 'application/msword', 'application/zip', 'application/x-rar-compressed', 'text/plain', 'text/rtf']
	
	validates_presence_of :email, :body
	validates_length_of :body, :within => 3..2024
	validates_format_of :email, :with => Authlogic::Regex.email
	
	belongs_to :job, :counter_cache => true
	attr_protected :job_id
end
