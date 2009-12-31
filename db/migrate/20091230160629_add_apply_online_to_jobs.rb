class AddApplyOnlineToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :apply_online, :boolean, :default => true
  end

  def self.down
    remove_column :jobs, :apply_online
  end
end
