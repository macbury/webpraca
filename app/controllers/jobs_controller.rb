class JobsController < ApplicationController
	validates_captcha :only => [:create, :new]
	ads_pos :bottom
	ads_pos :right, :except => [:home, :index, :search]
	ads_pos :none, :only => [:home]

	def home
		set_meta_tags :title => t('home.title'),
									:separator => " - "
		
		query = Job.active.search
		
		@recent_jobs = query.all(:order => "created_at DESC", :limit => 15, :include => [:localization, :category])
		@top_jobs = query.all(:order => "rank DESC, created_at DESC", :limit => 15, :include => [:localization, :category])
	end
  # GET /jobs
  # GET /jobs.xml
  def index
		@query = Job.active.search
		options = {
								:page => params[:page], 
								:per_page => 35,
								:order => "created_at DESC, rank DESC",
								:include => [:localization, :category]
							}
		
		if params[:order] =~ /popular/i
			@page_title = [t('title.popular')]
			@order = :rank
			options[:order] = "rank DESC, created_at DESC"
		else
			@order = :created_at
			@page_title = [t('title.latest')]
			options[:order] = "created_at DESC, rank DESC"
		end
		
		if params[:language]
			@language = Language.find_by_permalink!(params[:language])
			@page_title << @language.name.downcase
			@query.language_id_is(@language.id)
		end
		
		if params[:category]
			@category = Category.find_by_permalink!(params[:category])
			@page_title << @category.name.downcase
			@query.category_id_is(@category.id)
		end
		
		if params[:localization]
			@localization = Localization.find_by_permalink!(params[:localization])
			@page_title << @localization.name.downcase
			@query.localization_id_is(@localization.id)
		end
		
		if params[:framework]
			@framework = Framework.find_by_permalink!(params[:framework])
			@page_title << @framework.name.downcase
			options[:include] << :framework
			@query.framework_id_is(@framework.id)
		end
		
		if params[:type_id]
			@type_id = JOB_TYPES.index(params[:type_id]) || 0
			@page_title << JOB_TYPES[@type_id].downcase
			@query.type_id_is(@type_id)
		end
		
    @jobs = @query.paginate(options)

    respond_to do |format|
      format.html # index.html.erb
			format.rss
			format.atom
    end
  end
	
	def search
		@page_title = [t('title.search')]
		
		@search = Job.active.search(params[:search])
		if params[:search]
			@page_title = [t('title.finded_jobs')]
			@jobs = @search.paginate( :page => params[:page],
																:per_page => 30,
													 			:order => "created_at DESC, rank DESC" )
		end
    respond_to do |format|
      format.html
			format.rss { render :action => "index" }
			format.atom { render :action => "index" }
    end
	end
	
  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find_by_permalink!(params[:id])
		@job.visited_by(request.remote_ip)
		@category = @job.category
		
		@page_title = [t('title.jobs'), @job.category.name.downcase, @job.localization.name.downcase, @job.company_name.downcase, @job.title.downcase]
		
		@tags = t('head.tags').split(',').map(&:strip) + [@job.category.name, @job.localization.name, @job.company_name]
		@tags << JOB_TYPES[@job.type_id]
		
		unless @job.framework.nil?
			@tags << @job.framework.name 
			@page_title.insert(1, @job.framework.name)
		end
		
		unless @job.language.nil?
			@page_title.insert(1, @job.language.name)
			@tags << @job.language.name 
		end
		
		set_meta_tags :keywords => @tags.join(', ')
		
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
        flash[:notice] = t('flash.notice.email_verification')
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
        flash[:notice] = t('flash.notice.job_updated')
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
		unless @job.published
			@job.publish!
			flash[:notice] = t('flash.notice.job_published')
		end

		redirect_to @job
	end
	
  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find_by_permalink_and_token!(params[:id], params[:token])
    @job.destroy
		flash[:notice] = t('flash.notice.job_deleted')
    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end

end
