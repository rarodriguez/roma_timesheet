class CreateCompaniesUsers < ActiveRecord::Migration
  def self.up
    create_table :companies_users, :id=>false do |t|
      t.integer :company_id
      t.integer :user_id
    end
    add_foreign_key(:companies_users, :companies)
    add_foreign_key(:companies_users, :users)
  end

  def self.down
    drop_table :companies_users
  end
end
