Given /^a job titled "([^\"]*)" exists in category "([^\"]*)"$/ do |title, category_name|
  category = Category.find_by_name(category_name) || Factory.create(:category, :name => category_name)
  Factory.create(:job, :title => title, :category => category)
end
