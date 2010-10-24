class AddFieldsUsersAndPermissions < ActiveRecord::Migration
  def self.up
    add_column :users, :password_changed_at, :datetime
    add_column :permissions, :needs_extra_validation, :boolean
  end

  def self.down
    remove_column :users, :password_changed_at
    remove_column :permissions, :needs_extra_validation
  end
end
