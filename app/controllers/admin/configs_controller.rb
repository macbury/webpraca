class Admin::ConfigsController < ApplicationController
	before_filter :login_required
	layout 'admin'
	
  def new

  end
  
  def create
    WebSiteConfig.update_attributes(params["WebSiteConfig"])
		render :action => "new"
  end

end
