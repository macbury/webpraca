class RemoveKarmaFromJobs < ActiveRecord::Migration
  def self.up
		remove_column :jobs, :karma
		add_column :jobs, :rank, :integer, :defualt => 0
  end

  def self.down
  end
end
