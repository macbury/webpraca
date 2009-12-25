class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :type_id, :default => 0
      t.integer :price_from
      t.integer :price_to
      t.boolean :remote_job
      t.string :title
      t.string :permalink
      t.text :description
      t.date :end_at
      t.string :company_name
      t.string :website
      t.integer :localization_id
      t.integer :NIP
      t.integer :REGON
      t.integer :KRS
      t.string :email
      t.integer :karma

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
