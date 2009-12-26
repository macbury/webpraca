class AddPublishedToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :published, :boolean

		Job.all.each do |job|
			job.publish!
		end
  end

  def self.down
    remove_column :jobs, :published
  end
end
