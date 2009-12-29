class ChangeColumnToDowncaseInJobs < ActiveRecord::Migration
  def self.up
		rename_column :jobs, :NIP, :nip
		rename_column :jobs, :REGON, :regon
		rename_column :jobs, :KRS, :krs
  end

  def self.down
  end
end
