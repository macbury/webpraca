class ChangeIpColumnInVisits < ActiveRecord::Migration
  def self.up
		remove_column :visits, :ip
		add_column :visits, :ip, :bigint
  end

  def self.down
  end
end
