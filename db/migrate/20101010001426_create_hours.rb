class CreateHours < ActiveRecord::Migration
  def self.up
    create_table :hours do |t|
      t.text :description
      t.datetime :initial_time
      t.datetime :end_time
      t.integer :timesheet_id

      t.timestamps
    end
  end

  def self.down
    drop_table :hours
  end
end
