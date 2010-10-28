class CreateForeignKeys < ActiveRecord::Migration
  def self.up
    add_foreign_key(:companies,:users, :dependent => :delete)
    add_foreign_key(:projects, :users, :dependent => :delete)
    add_foreign_key(:users, :users, :column => 'last_updated_by', :dependent => :delete )
    add_foreign_key(:permissions, :roles, :dependent => :delete )
    add_foreign_key(:hours, :timecards, :dependent => :delete )
    add_foreign_key(:timecards,:users, :dependent => :delete )
    add_foreign_key(:timecards,:projects, :dependent => :delete )
    add_foreign_key(:timecards, :timecards_notes, :dependent => :delete )
    add_foreign_key(:projects_users, :projects, :dependent => :delete)
    add_foreign_key(:projects_users, :users, :dependent => :delete)
    add_foreign_key(:roles_users, :roles, :dependent => :delete)
    add_foreign_key(:roles_users, :users, :dependent => :delete)
    add_foreign_key(:historical_hours, :hours, :dependent => :delete)
    add_foreign_key(:historical_hours, :users, :column=>'created_by', :dependent => :delete)
    add_foreign_key(:timecards_notes, :timecards, :dependent => :delete)
    add_foreign_key(:timecards_notes, :users, :column => 'created_by', :dependent => :delete)
  end

  def self.down
    remove_foreign_key(:companies,:users)
    remove_foreign_key(:projects, :users)
    remove_foreign_key(:users, :users, :column => 'last_updated_by')
    remove_foreign_key(:permissions, :roles)
    remove_foreign_key(:hours, :timecards)
    remove_foreign_key(:timecards,:users)
    remove_foreign_key(:timecards,:projects)
    remove_foreign_key(:timecards, :timecards_notes)
    remove_foreign_key(:projects_users, :projects)
    remove_foreign_key(:projects_users, :users)
    remove_foreign_key(:roles_users, :roles)
    remove_foreign_key(:roles_users, :users)
    remove_foreign_key(:historical_hours, :hours)
    remove_foreign_key(:historical_hours, :users, :column=>'created_by')
    remove_foreign_key(:timecards_notes, :timecards)
    remove_foreign_key(:timecards_notes, :users, :column => 'created_by')
  end
end
