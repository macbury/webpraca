class Admin::CategoriesController < ApplicationController
	before_filter :login_required, :setup_title
	layout 'admin'
	
	def reorder
    params[:category].each_with_index do |id, position|
      category = Category.find(id)
      category.update_attribute('position', position + 1)
    end

		render :nothing => true
	end
	
  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.all(:order => "position")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
		@page_title << "Nowa kategoria"
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
		@page_title << "Edycja kategorii"
    @category = Category.find_by_permalink!(params[:id])
		render :action => "new"
  end

  # POST /categories
  # POST /categories.xml
  def create
		@page_title << "Nowa kategoria"
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(admin_categories_url) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
		@page_title << "Edycja kategorii"
    @category = Category.find_by_permalink!(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(admin_categories_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find_by_permalink!(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(admin_categories_url) }
      format.xml  { head :ok }
    end
  end
	
	protected
	
		def setup_title
			@page_title << "Kategorie"
		end
end
