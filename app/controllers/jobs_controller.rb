class JobsController < ApplicationController
	validates_captcha :only => [:create, :new, :edit, :update]
	
	def home
		@page_title = ['najpopularniejsze oferty', 'najnowsze oferty']
		
		query = Job.search
		query.active
		
		@recent_jobs = query.all(:order => "created_at DESC", :limit => 10, :include => :localization)
		@top_jobs = query.all(:order => "rank DESC", :limit => 10, :include => :localization)
	end
  # GET /jobs
  # GET /jobs.xml
  def index
		@query = Job.search
		@page_title = ['Oferty pracy']
		
		options = {
								:page => params[:page], 
								:per_page => 30,
								:order => "created_at DESC, rank DESC",
								:include => [:localization]
							}
		
		@query.active
		
		if params[:localization]
			@localization = Localization.find_by_permalink!(params[:localization])
			@page_title << @localization.name
			@query.localization_id_is(@localization.id)
		end
		
		if params[:framework]
			@framework = Framework.find_by_permalink!(params[:framework])
			@page_title << @framework.name
			options[:include] << :framework
			@query.framework_id_is(@framework.id)
		end
		
    @jobs = @query.paginate(options)

    respond_to do |format|
      format.html # index.html.erb
			format.rss
			format.atom
    end
  end
	
	def search
		@page_title = "Szukaj oferty"
		
		@search = Job.search(params[:search])
		@search.active
		
		@jobs = @search.all  :limit => 30, 
												 :order => "created_at DESC, rank DESC"
		
    respond_to do |format|
      format.html { render :action => (params[:search].nil? || params[:search].empty?) ? "search" : "results" }
			format.rss { render :action => "index" }
			format.atom { render :action => "index" }
    end
	end
	
  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find_by_permalink!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /jobs/new
  # GET /jobs/new.xml
  def new
    @job = Job.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    @job = Job.new(params[:job])

    respond_to do |format|
      if @job.save
        flash[:notice] = 'Na twój e-mail został wysłany link którym opublikujesz ofertę.'
        format.html { redirect_to(@job) }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end
	
	# GET /jobs/1/edit
  def edit
    @job = Job.find_by_permalink_and_token!(params[:id], params[:token])
		render :action => "new"
  end
	
  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    @job = Job.find_by_permalink_and_token!(params[:id], params[:token])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        flash[:notice] = 'Job was successfully updated.'
        format.html { redirect_to(@job) }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end
	
	def publish
		@job = Job.find_by_permalink_and_token!(params[:id], params[:token])
		@job.publish!
		
		flash[:notice] = "Twoja oferta jest już widoczna!"
		
		redirect_to @job
	end
	
  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find_by_permalink_and_token!(params[:id], params[:token])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end

end
