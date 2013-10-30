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

ActiveRecord::Schema.define(version: 20131018192706) do

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
    t.string   "email"
    t.date     "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
