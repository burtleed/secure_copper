# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20111226060618) do

  create_table "admin_hospitals", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.integer  "user_limit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_roles", :force => true do |t|
    t.string   "role_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apn_devices", :force => true do |t|
    t.string   "token",              :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_registered_at"
  end

  add_index "apn_devices", ["token"], :name => "index_apn_devices_on_token", :unique => true

  create_table "apn_notifications", :force => true do |t|
    t.integer  "device_id",                        :null => false
    t.integer  "errors_nb",         :default => 0
    t.string   "device_language"
    t.string   "sound"
    t.string   "alert"
    t.integer  "badge"
    t.text     "custom_properties"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apn_notifications", ["device_id"], :name => "index_apn_notifications_on_device_id"

  create_table "attachments", :force => true do |t|
    t.integer  "message_id"
    t.string   "description"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["message_id"], :name => "index_attachments_on_message_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "expire_settings_messages", :force => true do |t|
    t.integer  "user_id"
    t.string   "flag",           :limit => 1, :default => "0"
    t.integer  "lifespan_hours",              :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expire_settings_messages", ["user_id"], :name => "index_expire_settings_messages_on_user_id"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "favorable_id"
    t.string   "favorable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hospital_id"
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  add_index "groups_users", ["user_id", "group_id"], :name => "index_groups_users_on_user_id_and_group_id"

  create_table "memberships", :force => true do |t|
    t.integer  "member_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "allowed",    :default => true
  end

  add_index "memberships", ["user_id", "allowed"], :name => "index_memberships_on_user_id_and_allowed"

  create_table "message_recepients", :force => true do |t|
    t.integer  "message_id"
    t.integer  "recepient_id"
    t.boolean  "recepient_deleted", :default => false
    t.datetime "read_at"
  end

  add_index "message_recepients", ["message_id", "recepient_id"], :name => "index_message_recepients_on_message_id_and_recepient_id"

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.boolean  "sender_deleted", :default => false
    t.text     "body"
    t.datetime "expired_at"
    t.boolean  "expired"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "temp_file_uploads", :force => true do |t|
    t.string   "description"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.integer  "user_id"
    t.string   "queue_id_flag"
    t.string   "keyname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "temp_file_uploads", ["keyname", "user_id"], :name => "index_temp_file_uploads_on_keyname_and_user_id"
  add_index "temp_file_uploads", ["queue_id_flag", "user_id"], :name => "index_temp_file_uploads_on_queue_id_flag_and_user_id"

  create_table "titles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hospital_id"
  end

  add_index "titles", ["hospital_id"], :name => "index_titles_on_hospital_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                  :default => "",   :null => false
    t.string   "encrypted_password",     :limit => 128,  :default => "",   :null => false
    t.boolean  "status",                                 :default => true
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "primary_group_id"
    t.integer  "user_creation_limit",                    :default => 0
    t.integer  "hospital_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "phone_number"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "title_id"
    t.string   "reset_password_token"
    t.string   "device_type"
    t.string   "device_registration_id", :limit => 2000
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["hospital_id"], :name => "index_users_on_hospital_id"
  add_index "users", ["primary_group_id"], :name => "index_users_on_primary_group_id"
  add_index "users", ["role_id"], :name => "index_users_on_role_id"
  add_index "users", ["status"], :name => "index_users_on_status"
  add_index "users", ["title_id"], :name => "index_users_on_title_id"

end
