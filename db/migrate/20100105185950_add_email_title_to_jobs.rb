class AddEmailTitleToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :email_title, :string
  end

  def self.down
    remove_column :jobs, :email_title
  end
end
