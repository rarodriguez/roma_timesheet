class CreateHistoricalHours < ActiveRecord::Migration
  def self.up
   create_table :historical_hours do |t|
      t.text :old_value
      t.text :new_value
      t.integer :hour_id
      t.integer :created_by

      t.timestamps
    end
    
  end

  def self.down
    drop_table :historical_hours
  end
end
