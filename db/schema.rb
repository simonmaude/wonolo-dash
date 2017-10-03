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

ActiveRecord::Schema.define(version: 20171003174959) do

  create_table "stored_job_requests", force: :cascade do |t|
    t.integer  "job_id"
    t.datetime "completed_at"
    t.datetime "updated_at",   null: false
    t.string   "job_state"
    t.string   "category"
    t.datetime "created_at",   null: false
  end

  create_table "stored_jobs", force: :cascade do |t|
    t.integer  "job_id"
    t.datetime "completed_at"
    t.datetime "updated_at",    null: false
    t.string   "worker_first"
    t.string   "worker_second"
    t.string   "worker_avatar"
    t.string   "worker_state"
    t.string   "employer_name"
    t.datetime "created_at",    null: false
    t.string   "job_state"
  end

end
