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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150210175212) do

  create_table "categories", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name_code"
  end

  create_table "offers", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.date     "valid_until"
    t.integer  "status_id"
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "offers", ["category_id"], name: "index_offers_on_category_id"
  add_index "offers", ["status_id"], name: "index_offers_on_status_id"
  add_index "offers", ["valid_until"], name: "index_offers_on_valid_until"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "region"
    t.boolean  "active",          default: true
    t.boolean  "admin",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true

end
