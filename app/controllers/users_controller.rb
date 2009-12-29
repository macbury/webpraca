class UsersController < ApplicationController
	before_filter :not_for_production
	
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Rejestracja się powiodła"
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
end
