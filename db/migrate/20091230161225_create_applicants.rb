class CreateApplicants < ActiveRecord::Migration
  def self.up
    create_table :applicants do |t|
      t.string :email
      t.text :body
      t.integer :job_id
      t.timestamps
    end

		add_column :jobs, :applicants_count, :integer, :default => 0
  end
  
  def self.down
    drop_table :applicants
  end
end
