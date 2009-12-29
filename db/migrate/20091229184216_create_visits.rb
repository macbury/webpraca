class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.integer :ip
      t.integer :job_id

      t.timestamps
    end
		add_column :jobs, :visits_count, :integer, :default => 0
  end

  def self.down
    drop_table :visits

  end
end
