# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

['Ruby On Rails', 'Merb', 'Django', 'ASP .NET', 'Sinatra', 'Pylons', 'Symfony', 'CakePHP', 'Kohana', 'Spring', 'Struts', 'LifeRay'].each do |name|
	Framework.find_or_create_by_name(name)
end

['Warszawa', 'Kraków', 'Gdańsk', 'Radom', 'Kielce', 'Lublin', 'Łódź', 'Gdynia', 'Toruń'].each do |name|
	Localization.find_or_create_by_name(name)
end

['Programowanie', 'Grafika', 'Administracja', 'Zarządzanie'].each do |name|
	Category.find_or_create_by_name(name)
end