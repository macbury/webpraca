ActionController::Routing::Routes.draw do |map|
  
	map.new_contact '/contact/new', :controller => 'contact', :action => 'new', :conditions => { :method => :get }
  map.contact '/contact', :controller => 'contact', :action => 'new', :conditions => { :method => :get }
  map.contact '/contact', :controller => 'contact', :action => 'create', :conditions => { :method => :post }
	map.seo_page '/strona/:id/', :controller => 'admin/pages', :action => 'show'

	map.with_options :controller => 'jobs', :action => 'index' do |job| 
		job.with_options :category => nil, :page => 1, :order => "najnowsze", :requirements => { :order => /(najnowsze|najpopularniejsze)/, :page => /\d/ } do |seo|
			seo.connect '/oferty/:page'
			seo.connect '/oferty/:order'
			seo.connect '/oferty/:order/:page'
			seo.seo_jobs '/oferty/:order/:category/:page'
		end
		
		job.connect '/lokalizacja/:localization/:page'
		job.localization '/lokalizacja/:localization'
		job.connect '/framework/:framework/:page'
		job.framework '/framework/:framework'
		job.connect '/typ/:type_id/:page'
		job.job_type '/typ/:type_id'
		job.connect '/kategoria/:category/:page'
		job.job_category '/kategoria/:category'
	end
	
	map.resources :jobs, :member => { :publish => :get, :destroy => :any }, :collection => { :search => :any, :widget => :get } do |jobs|
		jobs.resources :applicants, :member => { :download => :get }
	end
	
  map.resources :user_sessions
	
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
	
	map.namespace :admin do |admin|
		admin.stats '/stats', :controller => "stats"
		admin.config '/config', :controller => "configs", :action => "new"
		admin.resources :pages
		admin.resources :jobs
		admin.resource :configs
		admin.resources :frameworks
		admin.resources :categories, :collection => { :reorder => :post }
	end

	map.admin '/admin', :controller => "admin/stats"
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
	map.root :controller => "jobs", :action => "home"
	map.seo_job '/:id', :controller => 'jobs', :action => 'show'
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
