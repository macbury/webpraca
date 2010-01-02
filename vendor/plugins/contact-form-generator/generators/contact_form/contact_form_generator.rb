require File.expand_path(File.dirname(__FILE__) + "/lib/insert_routes.rb")

class ContactFormGenerator < Rails::Generator::Base
  
  def manifest
      record do |m|
        
        # Controller
        m.file "controllers/contact_controller.rb", "app/controllers/contact_controller.rb"
        
        # Models
        m.file "models/contact_handler.rb", "app/models/contact_handler.rb"
        m.file "models/contact_mailer.rb", "app/models/contact_mailer.rb"
  
        # Specs
        if has_rspec?
          m.directory "spec/models"          
          m.file "spec/models/contact_handler_spec.rb", "spec/models/contact_handler_spec.rb"
          m.file "spec/models/contact_mailer_spec.rb", "spec/models/contact_mailer_spec.rb"          

          m.directory "spec/controllers"          
          m.file "spec/controllers/contact_controller_spec.rb", "spec/controllers/contact_controller_spec.rb"
          
          m.directory "spec/views/contact"          
          m.file "spec/views/contact/new.html.erb_spec.rb", "spec/views/contact/new.html.erb_spec.rb"          
        end

        # Views
        m.directory "app/views/contact"
        m.file "views/contact/new.html.erb", "app/views/contact/new.html.erb"
        m.directory "app/views/contact_mailer"
        m.file "views/contact_mailer/contact_notification.html.erb", "app/views/contact_mailer/contact_notification.html.erb"        
  
        # Routes
        m.route_name('contact', '/contact', { :controller => 'contact', :action => 'create', :conditions => { :method => :post }})
        m.route_name('contact', '/contact', { :controller => 'contact', :action => 'new', :conditions => { :method => :get }} )
        m.route_name('new_contact', '/contact/new', { :controller => 'contact', :action => 'new', :conditions => { :method => :get }})
        
        # Readme
        m.readme "INSTALL"
      end
    end
    
protected

  def has_rspec?
    spec_dir = File.join(RAILS_ROOT, 'spec')
    File.exist?(spec_dir) && File.directory?(spec_dir)
  end
  
end
