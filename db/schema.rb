# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100816203359) do

  create_table "groups", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "project_ids"
    t.string   "vote_done_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "status"
    t.text     "closed_msg"
  end

  create_table "paypal_postbacks", :force => true do |t|
    t.integer  "premium_transaction_id"
    t.string   "payer_business_name"
    t.string   "payer_email"
    t.string   "payment_status"
    t.string   "receiver_email"
    t.string   "business"
    t.decimal  "payment_gross",          :precision => 10, :scale => 2
    t.string   "txn_id"
    t.text     "raw"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pledges", :force => true do |t|
    t.integer  "project_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.decimal  "amount_pledged",       :precision => 10, :scale => 2
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "subscribe_me",                                        :default => true
    t.string   "internal_note"
    t.integer  "vote_id"
    t.integer  "user_id"
    t.datetime "payment_requested_at"
    t.datetime "paid_in_full_at"
    t.decimal  "amount_paid",          :precision => 10, :scale => 2, :default => 0.0
  end

  add_index "pledges", ["project_id"], :name => "index_pledges_on_project_id"

  create_table "premium_transactions", :force => true do |t|
    t.integer  "pledge_id"
    t.integer  "user_id"
    t.string   "type"
    t.decimal  "amount",     :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "url"
    t.integer  "pledges_count",                                        :default => 0
    t.datetime "pledge_deadline_at"
    t.string   "method"
    t.decimal  "pledge_goal_amount",    :precision => 10, :scale => 2
    t.decimal  "current_pledged_total", :precision => 10, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pledge_done_url"
    t.integer  "user_id"
    t.text     "status"
    t.text     "closed_msg"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tiny_urls", :force => true do |t|
    t.string   "key"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tiny_urls", ["key"], :name => "index_tiny_urls_on_key"

  create_table "users", :force => true do |t|
    t.string   "email",                                      :null => false
    t.string   "crypted_password",                           :null => false
    t.string   "password_salt",                              :null => false
    t.string   "persistence_token",                          :null => false
    t.string   "perishable_token",                           :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "site_name"
    t.string   "from_email"
    t.string   "pledge_confirmation_subject"
    t.text     "pledge_confirmation_body"
    t.integer  "login_count",                 :default => 0, :null => false
    t.integer  "failed_login_count",          :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "paypal_email"
    t.string   "pledge_invoice_subject"
    t.text     "pledge_invoice_body"
  end

  create_table "votes", :force => true do |t|
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
