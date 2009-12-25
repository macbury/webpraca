class ChangeNipColumnInJobs < ActiveRecord::Migration
  def self.up
		change_column :jobs, :NIP, :string
		change_column :jobs, :KRS, :string
		change_column :jobs, :REGON, :string
  end

  def self.down
  end
end
