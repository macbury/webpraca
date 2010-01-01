class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.string :permalink
      t.integer :position, :default => 0

      t.timestamps
    end
		add_column :jobs, :category_id, :integer
		
		Job.all.each do |job|
			job.category_id = 0
			job.save
		end
  end

  def self.down
    drop_table :categories
  end
end
