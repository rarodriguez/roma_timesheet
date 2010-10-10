class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.integer :company_id
      t.integer :user_id
      t.integer :last_update_by

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
