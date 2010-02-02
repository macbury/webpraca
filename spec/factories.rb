Factory.sequence :email do |n|
  "person#{n}@example.com"
end


Factory.define :job do |f|
  f.title { "Google CEO" }
  # it's faster to fing existing record, than create new one
  f.category { |c| Category.find(:first) || c.association(:category) }
  f.localization { |l| Localization.find(:first) || l.association(:localization) }
  f.type_id 0
  f.description "You'll probably like this job."
  f.company_name "Google"
  f.email "google@google.com"
  f.published true
	f.availability_time 14
	f.price_from 3000
	f.price_to 4000
	f.website "http://google.com/jobs"
	f.regon "141066449"
	f.nip "701-00-87-331"
	f.krs "0000287684"
end

Factory.define :applicant do |f|
  f.email { Factory.next(:email) }
  f.body "I am the boss"
  f.job { |j| Job.find(:first) || j.association(:job) }
  f.cv_file_name "lorem_cv.pdf"
  f.cv_content_type "application/pdf"
  f.cv_file_size 1024
  f.token "f9ece2216c3e25961b1e7f0ed428f1bed0015f72"
end

Factory.define :category do |f|
  f.sequence(:name) {|n| "category #{n}" }
end

Factory.define :localization do |f|
  f.name "Warszawa"
  f.permalink "warszawa"
end