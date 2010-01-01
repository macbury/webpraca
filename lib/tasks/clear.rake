namespace :webpraca do
	namespace :clear do
		task :applicants => :environment do
			Applicant.all.each(&:destroy)
		end
		
		task :visits => :environment do
			Visit.all.each(&:destroy)
		end
	end
	
	namespace :jobs do
		task :remove_old => :environment do
			Job.old.each(&:destroy)
		end
	end
end