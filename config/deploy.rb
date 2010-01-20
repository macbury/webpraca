set :application, "webpraca"
set :repository, "git://github.com/macbury/webpraca.git"
set :scm, :git

set :branch, "deploy"
set :user, "webpraca"
set :deploy_to, "/home/webpraca/www/apps/#{application}"
set :rails_env, "production"
set :use_sudo, false

role :app, "webpraca.megiteam.pl"
role :web, "webpraca.megiteam.pl"
role :db, "webpraca.megiteam.pl", :primary => true

after "deploy:symlink", "deploy:symlink_uploaded"
after "deploy:symlink", "deploy:install_gems"
after "deploy:symlink", "deploy:rebuild_assets"
after "deploy:symlink", "deploy:update_crontab"
after "deploy:symlink", "deploy:copy_old_sitemap"

namespace :deploy do
	desc "Restart aplikacji przy pomocy skryptu Megiteam"
	
	task :restart, :role => :app do
		run "cd #{deploy_to}/current; restart-app webpraca"
		run "cd #{deploy_to}/current; echo RAILS_ENV='production' > .environment"
	end

	desc "start"
		task :start, :role => :app do
		run "restart-app #{ application }"
	end

	desc "stop"
		task :stop, :role => :app do
			run "restart-app #{ application }"
	end

	desc "Stworz symlinki do wspoldzielonych plikow"
	task :symlink_uploaded, :roles => :app do
		
		run "ln -nfs #{shared_path}/config/mailer.yml #{current_path}/config/mailer.yml"
		run "ln -nfs #{shared_path}/config/exception_notifier.yml #{current_path}/config/exception_notifier.yml"
		run "ln -nfs #{shared_path}/config/website_config.yml #{current_path}/config/website_config.yml"
		run "ln -nfs #{shared_path}/config/micro_feed.yml #{current_path}/config/micro_feed.yml"
		run "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml"
		run "ln -nfs #{shared_path}/config/newrelic.yml #{current_path}/config/newrelic.yml"
		run "ln -nfs #{shared_path}/public/images/captchas #{current_path}/public/images/captchas"
		run "ln -nfs #{shared_path}/tmp/attachments #{current_path}/tmp/attachments"
	end


	desc "Rebuild asset files"
	task :rebuild_assets, :roles => :app do
		run "cd #{ current_path } ; rake more:parse"
		run "cd #{ current_path } ; rake asset:packager:delete_all"
		run "cd #{ current_path } ; rake asset:packager:build_all"
	end
	
	task :copy_old_sitemap do
		run "if [ -e #{previous_release}/public/sitemap_index.xml.gz ]; then cp #{previous_release}/public/sitemap* #{current_release}/public/; fi"
  end
	
	task :captchas, :roles => :app do
		run "cd #{ current_path } ; rake validates_captcha:create_static_images COUNT=50"
	end
	
	desc "Install gems"
	task :install_gems, :roles => :app do
		run "cd #{ current_path } ; rake gems:install"
	end
	
	desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
	
	task :publish, :roles => :db do
		run "cd #{release_path} && rake webpraca:jobs:publish RAILS_ENV=production"
		
	end
end
