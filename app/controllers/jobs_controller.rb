class JobsController < ApplicationController
  # GET /jobs
  # GET /jobs.xml
  def index
		query = Job.search

		options = {
								:page => params[:page], 
								:per_page => 30,
								:order => "rank ASC, created_at DESC",
								:include => [:localization]
							}
		
		query.end_at_greater_than_or_equal_to(Date.current)
		#query.etat_equals(params[:etat]) if params[:etat]
		#query.place_id_equals(params[:place]) if params[:place]
		
		#if params[:type]
		#	type = OFFER_TYPES.map{ |type| PermalinkFu.escape(type) }.index(params[:type])
		#	query.type_id_equals(type)
		#end
		
    @jobs = query.paginate(options)
		
		@places = query.all 			:select => "count(jobs.localization_id) as jobs_count, localizations.*",
															:joins => :localization,
															:group => Localization.column_names.map{|c| "localizations.#{c}"}.join(','),
															:order => "localizations.name"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
			format.rss
    end
  end

  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find_by_permalink!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job }
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

  # GET /jobs/1/edit
  def edit
    @job = Job.find_by_permalink!(params[:id])
		render :action => "new"
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    @job = Job.new(params[:job])

    respond_to do |format|
      if @job.save
        flash[:notice] = 'Job was successfully created.'
        format.html { redirect_to(@job) }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    @job = Job.find_by_permalink!(params[:id])

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

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end
end
