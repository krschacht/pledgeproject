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

ActiveRecord::Schema.define(:version => 20100622022429) do

  create_table "pledges", :force => true do |t|
    t.integer  "project_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.decimal  "amount",        :precision => 10, :scale => 0
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "paid",                                         :default => false
    t.boolean  "subscribe_me",                                 :default => true
    t.string   "internal_note"
  end

  add_index "pledges", ["project_id"], :name => "index_pledges_on_project_id"

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
  end

end
