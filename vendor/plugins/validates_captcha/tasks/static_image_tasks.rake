namespace :validates_captcha do
  desc "Create 3 static captcha images in RAILS_ROOT/public/images/captchas/, specify a different number with COUNT=n"
  task :create_static_images => [:create_static_image_dir, :clear_static_image_dir] do
    count = ENV['COUNT'] ? ENV['COUNT'].to_i : 3

    count.times do
      path, code = ValidatesCaptcha::Provider::StaticImage.create_image
      puts "Created #{path} with code #{code}"
    end
  end

  task :create_static_image_dir => :environment do
    image_dir = ValidatesCaptcha::Provider::StaticImage.filesystem_dir

    unless File.exist?(image_dir)
      FileUtils.mkdir_p image_dir
      puts "Created directory #{image_dir}"
    end
  end

  task :clear_static_image_dir => :environment do
    image_dir = ValidatesCaptcha::Provider::StaticImage.filesystem_dir
    image_files = Dir[File.join(image_dir, '*')]

    if image_files.any?
      FileUtils.rm image_files
      puts "Cleared directory #{image_dir}"
    end
  end
end

