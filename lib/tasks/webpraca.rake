require 'highline/import'

def ask_for_password(message)
	val = ask(message) {|q| q.echo = false}
	if val.nil? || val.empty?
		return ask_for_password(message)
	else
		return val
	end
end

def ask(message)
	puts "#{message}:"
	val = STDIN.gets.chomp
	if val.nil? || val.empty?
		return ask(message)
	else
		return val
	end
end

def render_errors(obj)
	index = 0
	obj.errors.each_full do |msg|
		index += 1
		puts "#{index}. #{msg}"
	end
end

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
		
		task :publish_all => :environment do
			Job.all.each do |job|
				job.publish!
			end
		end
	end
	
	namespace :admin do
		task :create => :environment do
			puts "Creating new admin user"
			user = User.new
			user.email = ask("Enter E-Mail")
			user.password = ask_for_password("Enter Password")
			user.password_confirmation = ask_for_password("Enter password confirmation")
			if user.save
				puts "Created admin user!"
			else
				render_errors(user)
			end
		end
	end
end