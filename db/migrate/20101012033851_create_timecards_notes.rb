class CreateTimecardsNotes < ActiveRecord::Migration
  def self.up
    create_table :timecards_notes do |t|
      t.integer :old_status
      t.integer :current_status
      t.text :justification
      t.integer :timecard_id
      t.integer :created_by

      t.timestamps
    end
  end

  def self.down
    drop_table :timecards_notes
  end
end
