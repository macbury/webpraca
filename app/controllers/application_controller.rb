class ApplicationController < ActionController::Base
	include ExceptionNotifiable
	
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user, :logged_in?, :own?
  
  before_filter :staging_authentication, :seo, :user_for_authorization
	
	def rescue_action_in_public(exception)
	  case exception
	  when ActiveRecord::RecordNotFound
	    render_404
		when ActionController::RoutingError
			render_404
		when ActionController::UnknownController
			render_404
		when ActionController::UnknownAction
			render_404
		else
			render_500
	  end
	end

  protected
	
	def render_404
		@page_title = ["Błąd 404", "Nie znaleziono strony"]
		render :template => "shared/error_404", :layout => 'application', :status => :not_found
	end

	def render_500
		@page_title = ["Błąd 500", "Coś poszło nie tak"]
		render :template => "shared/error_500", :layout => 'application', :status => :internal_server_error
	end
	
	def not_for_production
		redirect_to root_path if Rails.env == "production"
	end
	
	# Ads Position
	# :bottom, :right, :none
	def self.ads_pos(position, options = {})
    before_filter(options) do |controller|
      controller.instance_variable_set('@ads_pos', position)
    end
  end
	
	def user_for_authorization
		Authorization.current_user = self.current_user
	end
	
	def permission_denied
    flash[:error] = t('flash.error.access_denied')
    redirect_to root_url
  end
	
	def seo
		@ads_pos = :bottom
		set_meta_tags :description => WebSiteConfig['website']['description'],
	                :keywords => WebSiteConfig['website']['tags']
		
	end
	
  def staging_authentication
    if ENV['RAILS_ENV'] == 'staging'
      authenticate_or_request_with_http_basic do |user_name, password|
        user_name == "change this" && password == "and this"
      end
    end
  end

  
  def current_user_session
    @current_user_session ||= UserSession.find
    return @current_user_session
  end
  
  def current_user
    @current_user ||= self.current_user_session && self.current_user_session.user
    return @current_user
  end

  def logged_in?
    !self.current_user.nil?
  end

  def own?(object)
    logged_in? && self.current_user.own?(object)
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default
    redirect_to session[:return_to] || admin_path
    session[:return_to] = nil
  end

  def login_required
    unless logged_in?
      respond_to do |format|
        format.html do
          flash[:error] = t('flash.error.access_denied')
          store_location
          redirect_to login_path
        end
        format.js { render :js => "window.location = #{login_path.inspect};" }
      end
		else
			@page_title = [t('title.admin')]
    end
  end
end