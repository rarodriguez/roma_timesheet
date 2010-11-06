class NeedsExtraValidationDefaultTrue < ActiveRecord::Migration
  def self.up
    change_column :permissions, :needs_extra_validation, :boolean, :default => true
    Permission.update_all ["needs_extra_validation = ?", true], ["needs_extra_validation = ?", nil]  
  end

  def self.down
  end
end
