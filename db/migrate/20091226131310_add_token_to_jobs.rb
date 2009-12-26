class AddTokenToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :token, :string
		Job.all.each do |job|
			job.generate_token
			job.save
		end
  end

  def self.down
    remove_column :jobs, :token
  end
end
