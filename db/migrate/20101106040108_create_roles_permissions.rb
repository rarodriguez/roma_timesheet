class CreateRolesPermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions_roles, :id=>false do |t|
      t.integer :role_id
      t.integer :permission_id
    end
    add_foreign_key(:permissions_roles, :roles)
    add_foreign_key(:permissions_roles, :permissions)
    
    remove_foreign_key(:permissions, :roles)
    remove_column :permissions, :role_id
  end

  def self.down
    add_column :permissions, :role_id, :integer, :default => 1
    add_foreign_key(:permissions, :roles, :dependent => :delete )
    drop_table :permissions_roles
  end
end
