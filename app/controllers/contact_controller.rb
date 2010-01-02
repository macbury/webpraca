class ContactController < ApplicationController
	validates_captcha_of ContactHandler
	ads_pos :right
	
  def new
    @contact_handler = ContactHandler.new
		@contact_handler.job_id = params[:job_id]
  end

  def create
    @contact_handler = ContactHandler.new(params[:contact_handler])

    if @contact_handler.valid?
      ContactMailer.deliver_contact_notification(@contact_handler)
      flash[:notice] = 'Dziękujemy za wiadomość!'
      redirect_to root_path
    else
      render :action => "new"
    end
  end
  
end