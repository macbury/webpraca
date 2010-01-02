class ContactHandler < ActiveForm

  validates_presence_of :subject, :body
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  attr_accessor :subject, :email, :body

end