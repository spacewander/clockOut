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

ActiveRecord::Schema.define(version: 20140915021830) do

  create_table "activities", force: true do |t|
    t.string   "name",                default: "",    null: false
    t.integer  "days",                default: 30,    null: false
    t.integer  "finished_days"
    t.integer  "missed_days"
    t.integer  "missed_limit",        default: 10,    null: false
    t.integer  "drop_out_days"
    t.integer  "drop_out_limit",      default: 5,     null: false
    t.text     "content"
    t.boolean  "finished",            default: false, null: false
    t.boolean  "aborted",             default: false, null: false
    t.boolean  "public",              default: false, null: false
    t.integer  "group_id"
    t.integer  "creater"
    t.integer  "visited_count"
    t.integer  "participants_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feelings", force: true do |t|
    t.integer  "mission_id"
    t.text     "content"
    t.string   "day_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "missions", force: true do |t|
    t.string   "name",           default: "",           null: false
    t.integer  "days",           default: 30,           null: false
    t.integer  "finished_days"
    t.integer  "missed_days"
    t.integer  "missed_limit",   default: 10,           null: false
    t.integer  "drop_out_days"
    t.integer  "drop_out_limit", default: 5,            null: false
    t.text     "content"
    t.boolean  "finished",       default: false,        null: false
    t.boolean  "aborted",        default: false,        null: false
    t.boolean  "public",         default: false,        null: false
    t.integer  "user_id"
    t.boolean  "supervised",     default: false,        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "last_clock_out", default: '2014-09-15'
  end

  create_table "participantions", force: true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supervisions", force: true do |t|
    t.integer  "user_id"
    t.integer  "mission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name",              default: "", null: false
    t.string   "sex"
    t.integer  "year"
    t.string   "date"
    t.string   "password_hash",                  null: false
    t.string   "salt"
    t.date     "join_date"
    t.string   "email",                          null: false
    t.date     "last_actived"
    t.integer  "member_no"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_missions",  default: 0
    t.integer  "finished_missions", default: 0
    t.integer  "current_missions",  default: 0
  end

end
