class CreateForeignKeys < ActiveRecord::Migration
  def self.up
    add_foreign_key(:companies,:users)
    add_foreign_key(:projects, :users)
    add_foreign_key(:users, :users, :column => 'last_updated_by' )
    add_foreign_key(:permissions, :roles )
    add_foreign_key(:hours, :timecards )
    add_foreign_key(:timecards,:users )
    add_foreign_key(:timecards,:projects )
    add_foreign_key(:timecards, :timecards_notes )
    add_foreign_key(:projects_users, :projects)
    add_foreign_key(:projects_users, :users)
    add_foreign_key(:roles_users, :roles)
    add_foreign_key(:roles_users, :users)
    add_foreign_key(:historical_hours, :hours)
    add_foreign_key(:historical_hours, :users, :column=>'created_by')
    add_foreign_key(:timecards_notes, :timecards )
    add_foreign_key(:timecards_notes, :users, :column => 'created_by' )
  end

  def self.down
  end
end
