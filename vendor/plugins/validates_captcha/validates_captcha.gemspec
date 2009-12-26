Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'validates_captcha'
  s.version = '0.9.6'
  s.date = '2009-10-30'
  s.summary = "Captcha verification for Rails using ActiveRecord's validation mechanism"
  s.description = "A captcha verification approach for Rails apps, directly integrated into ActiveRecord’s validation mechanism and providing helpers for ActionController and ActionView."

  #s.files = Dir['[A-Z]*', 'lib/**/*', 'test/**/*', 'tasks/**/*', 'rails/*'].sort # insecure
  s.files = ["CHANGELOG.rdoc", "MIT-LICENSE", "README.rdoc", "Rakefile", "lib/validates_captcha", "lib/validates_captcha.rb", "lib/validates_captcha/controller_validation.rb", "lib/validates_captcha/form_builder.rb", "lib/validates_captcha/form_helper.rb", "lib/validates_captcha/image_generator", "lib/validates_captcha/image_generator/simple.rb", "lib/validates_captcha/model_validation.rb", "lib/validates_captcha/provider", "lib/validates_captcha/provider/dynamic_image.rb", "lib/validates_captcha/provider/question.rb", "lib/validates_captcha/provider/static_image.rb", "lib/validates_captcha/string_generator", "lib/validates_captcha/string_generator/simple.rb", "lib/validates_captcha/symmetric_encryptor", "lib/validates_captcha/symmetric_encryptor/simple.rb", "lib/validates_captcha/test_case.rb", "lib/validates_captcha/version.rb", "rails/init.rb", "tasks/static_image_tasks.rake", "test/cases", "test/cases/controller_validation_test.rb", "test/cases/image_generator", "test/cases/image_generator/simple_test.rb", "test/cases/model_validation_test.rb", "test/cases/provider", "test/cases/provider/dynamic_image_test.rb", "test/cases/provider/question_test.rb", "test/cases/provider/static_image_test.rb", "test/cases/string_generator", "test/cases/string_generator/simple_test.rb", "test/cases/symmetric_encryptor", "test/cases/symmetric_encryptor/simple_test.rb", "test/cases/validates_captcha_test.rb", "test/test_helper.rb"]

  #s.test_files = Dir['test/**/*'].sort # insecure
  s.test_files = ["test/cases", "test/cases/controller_validation_test.rb", "test/cases/image_generator", "test/cases/image_generator/simple_test.rb", "test/cases/model_validation_test.rb", "test/cases/provider", "test/cases/provider/dynamic_image_test.rb", "test/cases/provider/question_test.rb", "test/cases/provider/static_image_test.rb", "test/cases/string_generator", "test/cases/string_generator/simple_test.rb", "test/cases/symmetric_encryptor", "test/cases/symmetric_encryptor/simple_test.rb", "test/cases/validates_captcha_test.rb", "test/test_helper.rb"]

  s.add_dependency 'actionpack', '>= 2.3.2'
  s.add_dependency 'activerecord', '>= 2.3.2'

  s.require_path = 'lib'

  s.has_rdoc = true
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "MIT-LICENSE", "README.rdoc"]
  s.rdoc_options << '--title' << "Validates Captcha #{s.version}" << '--main' << 'README.rdoc' << '--line-numbers' << '--inline-source' << '--charset' << 'utf-8'

  s.author = 'Martin Andert'
  s.email = 'martin@mehringen.de'
  s.homepage = 'http://m4n.github.com/validates_captcha'
  s.rubyforge_project = 'validatecaptcha'
end

