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

ActiveRecord::Schema.define(:version => 20120315221317) do

  create_table "feeds", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "updated"
    t.datetime "added"
    t.integer  "entries"
    t.integer  "unread",     :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "feed_id"
    t.string   "title"
    t.string   "url"
    t.string   "guid"
    t.datetime "added",       :default => '2012-03-18 13:09:03'
    t.integer  "is_viewed",   :default => 0
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.text     "description"
    t.text     "sanitized"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
