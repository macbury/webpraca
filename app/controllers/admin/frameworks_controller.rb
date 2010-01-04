class Admin::FrameworksController < ApplicationController
	before_filter :login_required
	layout 'admin'
  # GET /frameworks
  # GET /frameworks.xml
  def index
    @frameworks = Framework.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @frameworks }
    end
  end


  # GET /frameworks/new
  # GET /frameworks/new.xml
  def new
    @framework = Framework.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @framework }
    end
  end

  # GET /frameworks/1/edit
  def edit
    @framework = Framework.find(params[:id])
  end

  # POST /frameworks
  # POST /frameworks.xml
  def create
    @framework = Framework.new(params[:framework])

    respond_to do |format|
      if @framework.save
        flash[:notice] = 'Framework was successfully created.'
        format.html { redirect_to(@framework) }
        format.xml  { render :xml => @framework, :status => :created, :location => @framework }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @framework.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /frameworks/1
  # PUT /frameworks/1.xml
  def update
    @framework = Framework.find(params[:id])

    respond_to do |format|
      if @framework.update_attributes(params[:framework])
        flash[:notice] = 'Framework was successfully updated.'
        format.html { redirect_to(@framework) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @framework.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /frameworks/1
  # DELETE /frameworks/1.xml
  def destroy
    @framework = Framework.find(params[:id])
    @framework.destroy

    respond_to do |format|
      format.html { redirect_to(frameworks_url) }
      format.xml  { head :ok }
    end
  end
end
