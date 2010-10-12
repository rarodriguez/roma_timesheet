# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101012050609) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["user_id"], :name => "companies_user_id_fk"

  create_table "historical_hours", :force => true do |t|
    t.text     "old_value"
    t.text     "new_value"
    t.integer  "hour_id"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "historical_hours", ["created_by"], :name => "historical_hours_created_by_fk"
  add_index "historical_hours", ["hour_id"], :name => "historical_hours_hour_id_fk"

  create_table "hours", :force => true do |t|
    t.text     "description"
    t.datetime "initial_time"
    t.datetime "end_time"
    t.integer  "timecard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hours", ["timecard_id"], :name => "hours_timecard_id_fk"

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["role_id"], :name => "permissions_role_id_fk"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.integer  "user_id"
    t.integer  "last_update_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["user_id"], :name => "projects_user_id_fk"

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  add_index "projects_users", ["project_id"], :name => "projects_users_project_id_fk"
  add_index "projects_users", ["user_id"], :name => "projects_users_user_id_fk"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "roles_users_role_id_fk"
  add_index "roles_users", ["user_id"], :name => "roles_users_user_id_fk"

  create_table "timecards", :force => true do |t|
    t.datetime "initial_time"
    t.datetime "end_time"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "timecards_note_id"
    t.integer  "last_update_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timecards", ["project_id"], :name => "timecards_project_id_fk"
  add_index "timecards", ["timecards_note_id"], :name => "timecards_timecards_note_id_fk"
  add_index "timecards", ["user_id"], :name => "timecards_user_id_fk"

  create_table "timecards_notes", :force => true do |t|
    t.integer  "old_status"
    t.integer  "current_status"
    t.text     "justification"
    t.integer  "timecard_id"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timecards_notes", ["created_by"], :name => "timecards_notes_created_by_fk"
  add_index "timecards_notes", ["timecard_id"], :name => "timecards_notes_timecard_id_fk"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "name"
    t.string   "last_name"
    t.string   "email"
    t.string   "persistence_token"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "current_login_at"
    t.datetime "last_request_at"
    t.integer  "failed_login_count"
    t.integer  "last_updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["last_updated_by"], :name => "users_last_updated_by_fk"

  add_foreign_key "companies", "users", :name => "companies_user_id_fk"

  add_foreign_key "historical_hours", "hours", :name => "historical_hours_hour_id_fk"
  add_foreign_key "historical_hours", "users", :name => "historical_hours_created_by_fk", :column => "created_by"

  add_foreign_key "hours", "timecards", :name => "hours_timecard_id_fk"

  add_foreign_key "permissions", "roles", :name => "permissions_role_id_fk"

  add_foreign_key "projects", "users", :name => "projects_user_id_fk"

  add_foreign_key "projects_users", "projects", :name => "projects_users_project_id_fk"
  add_foreign_key "projects_users", "users", :name => "projects_users_user_id_fk"

  add_foreign_key "roles_users", "roles", :name => "roles_users_role_id_fk"
  add_foreign_key "roles_users", "users", :name => "roles_users_user_id_fk"

  add_foreign_key "timecards", "projects", :name => "timecards_project_id_fk"
  add_foreign_key "timecards", "timecards_notes", :name => "timecards_timecards_note_id_fk"
  add_foreign_key "timecards", "users", :name => "timecards_user_id_fk"

  add_foreign_key "timecards_notes", "timecards", :name => "timecards_notes_timecard_id_fk"
  add_foreign_key "timecards_notes", "users", :name => "timecards_notes_created_by_fk", :column => "created_by"

  add_foreign_key "users", "users", :name => "users_last_updated_by_fk", :column => "last_updated_by"

end
