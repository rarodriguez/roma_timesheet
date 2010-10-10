class CreateTimecards < ActiveRecord::Migration
  def self.up
    create_table :timecards do |t|
      t.datetime :initial_time
      t.datetime :end_time
      t.integer :user_id
      t.integer :project_id
      t.integer :timesheets_note_id
      t.integer :last_update_by

      t.timestamps
    end
  end

  def self.down
    drop_table :timecards
  end
end
