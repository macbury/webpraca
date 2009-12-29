class ChangeRankInJobs < ActiveRecord::Migration
  def self.up
		change_column :jobs, :rank, :float
  end

  def self.down
  end
end
