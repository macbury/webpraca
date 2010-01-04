class JobsController < ApplicationController
	validates_captcha :only => [:create, :new]
	ads_pos :bottom
	ads_pos :right, :except => [:home, :index, :search]
	ads_pos :none, :only => [:home]
	
	def home
		@page_title = ['najpopularniejsze oferty', 'najnowsze oferty']
		
		query = Job.active.search
		
		@recent_jobs = query.all(:order => "created_at DESC", :limit => 10, :include => [:localization, :category])
		@top_jobs = query.all(:order => "rank DESC, created_at DESC", :limit => 10, :include => [:localization, :category])
	end
  # GET /jobs
  # GET /jobs.xml
  def index
		@query = Job.search
		options = {
								:page => params[:page], 
								:per_page => 25,
								:order => "created_at DESC, rank DESC",
								:include => [:localization, :category]
							}
		
		@query.active
		
		if params[:order] =~ /najpopularniejsze/i
			@page_title = ['Najpopularniejsze oferty pracy']
			@order = :rank
			options[:order] = "rank DESC, created_at DESC"
		else
			@order = :created_at
			@page_title = ['Najnowsze oferty pracy']
			options[:order] = "created_at DESC, rank DESC"
		end
		
		if params[:category]
			@category = Category.find_by_permalink!(params[:category])
			@page_title << @category.name
			@query.category_id_is(@category.id)
		end
		
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
		
		if params[:type_id]
			@type_id = JOB_LABELS.index(params[:type_id]) || 0
			@page_title << JOB_LABELS[@type_id]
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
		@page_title = ["Szukaj oferty"]
		
		@search = Job.active.search(params[:search])
		if params[:search]
			@page_title = ["Znalezione oferty"]
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
        flash[:notice] = 'Zapisano zmiany w ofercie.'
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
			flash[:notice] = "Twoja oferta jest już widoczna!"
			
			spawn do
				tags = [@job.localization.name, @job.category.name]
				tags << @job.framework.name unless @job.framework.nil?
				
				if Rails.env == "production"
					MicroFeed.send	:streams => :all,
													:msg => "[#{@job.company_name}] - #{@job.title}",
													:tags => tags,
													:link => seo_job_url(@job)
				end
			end
		end

		redirect_to @job
	end
	
  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find_by_permalink_and_token!(params[:id], params[:token])
    @job.destroy
		flash[:notice] = "Oferta została usunięta"
    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end

end
