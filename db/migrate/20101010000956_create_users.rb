class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login
      t.string :crypted_password
      t.string :salt
      t.varchar :name
      t.string :last_name
      t.string :email
      t.string :persistence_token
      t.string :current_login_ip
      t.varchar :last_login_ip
      t.datetime :current_login_at
      t.datetime :last_request_at
      t.integer :failed_login_count
      t.integer :last_udated_by

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
