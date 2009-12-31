# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://webpraca.net"

SitemapGenerator::Sitemap.add_links do |sitemap|
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: sitemap.add path, options
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly', 
  #           :lastmod => Time.now, :host => default_host

  
  # Examples:
  
  # add '/articles'
  sitemap.add jobs_path, :priority => 1.0, :changefreq => 'daily'
	sitemap.add popular_jobs_path
  # add all individual articles
  Job.active.each do |o|
    sitemap.add seo_job_path(o), :lastmod => o.updated_at
  end
  
	Framework.all.each do |f|
		latest_job = f.jobs.first(:order => "created_at DESC")
		sitemap.add framework_path(f), :lastmod => latest_job.nil? ? f.created_at : latest_job.created_at
	end
	
	Localization.all.each do |l|
		latest_job = l.jobs.first(:order => "created_at DESC")
		sitemap.add localization_path(l), :lastmod => latest_job.nil? ? l.created_at : latest_job.created_at
	end
end

# Including Sitemaps from Rails Engines.
#
# These Sitemaps should be almost identical to a regular Sitemap file except 
# they needn't define their own SitemapGenerator::Sitemap.default_host since
# they will undoubtedly share the host name of the application they belong to.
#
# As an example, say we have a Rails Engine in vendor/plugins/cadability_client
# We can include its Sitemap here as follows:
# 
# file = File.join(Rails.root, 'vendor/plugins/cadability_client/config/sitemap.rb')
# eval(open(file).read, binding, file)