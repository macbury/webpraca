class AddTokenToApplicant < ActiveRecord::Migration
  def self.up
    add_column :applicants, :token, :string
  end

  def self.down
    remove_column :applicants, :token
  end
end
