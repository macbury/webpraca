class CreateFrameworks < ActiveRecord::Migration
  def self.up
    create_table :frameworks do |t|
      t.string :name
      t.string :permalink

      t.timestamps
    end

		add_column :jobs, :framework_id, :integer
  end

  def self.down
    drop_table :frameworks
  end
end
