class User < ActiveRecord::Base
	xss_terminate

	acts_as_authentic do |c|
		login_field :email 
	end
	
	attr_protected :roles, :assignments
	
	has_many :assignments, :dependent => :destroy
  has_many :roles, :through => :assignments
	has_many :achievements, :dependent => :destroy
	
	def role_symbols
    roles.map { |role| role.name.underscore.to_sym }
  end
  
  def assign_role(role_name)
    role = Role.find_or_create_by_name(role_name)
    assignments.find_or_create_by_role_id(role.id)
  end

end
