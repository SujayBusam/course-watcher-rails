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

ActiveRecord::Schema.define(version: 20140805001712) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_selections", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "course_initially_available", default: false
    t.boolean  "user_needs_notified",        default: true
  end

  add_index "course_selections", ["course_id"], name: "index_course_selections_on_course_id", using: :btree
  add_index "course_selections", ["user_id", "course_id"], name: "index_course_selections_on_user_id_and_course_id", unique: true, using: :btree
  add_index "course_selections", ["user_id"], name: "index_course_selections_on_user_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "subject"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "crn"
    t.integer  "section"
    t.string   "title"
    t.string   "cross_list"
    t.string   "room"
    t.string   "building"
    t.string   "instructor"
    t.string   "world_culture"
    t.integer  "limit"
    t.integer  "enrollment"
    t.string   "status"
    t.string   "period"
    t.string   "distrib"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
