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

ActiveRecord::Schema.define(version: 20131121012759) do

  create_table "admins", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "courseID"
    t.date     "startDate"
    t.string   "title"
    t.string   "instructor"
    t.string   "description"
    t.integer  "intesity"
    t.string   "additional"
    t.string   "duration"
    t.time     "startTime"
    t.time     "endTime"
    t.string   "dayOfWeek"
    t.integer  "earlybirdPrice"
    t.integer  "memberPrice"
    t.integer  "nonmemberPrice"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollments", force: true do |t|
    t.string   "participantID"
    t.string   "courseID"
    t.date     "startDate"
    t.integer  "waitlist_status"
    t.integer  "waitlist_price"
    t.boolean  "disclaimer"
    t.boolean  "ans1"
    t.boolean  "ans2"
    t.boolean  "ans3"
    t.boolean  "ans4"
    t.boolean  "ans5"
    t.boolean  "ans6"
    t.boolean  "ans7"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participants", force: true do |t|
    t.string   "participantID"
    t.string   "fname"
    t.string   "lname"
    t.integer  "phone"
    t.date     "expirydate"
    t.date     "dr_note_date"
    t.string   "password"
    t.date     "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "role"
  end

  add_index "participants", ["email"], name: "index_participants_on_email", unique: true
  add_index "participants", ["reset_password_token"], name: "index_participants_on_reset_password_token", unique: true

end
