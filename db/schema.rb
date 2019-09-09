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

ActiveRecord::Schema.define(version: 2019_09_09_092517) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendance_logs", force: :cascade do |t|
    t.integer "roll_number", null: false
    t.date "log_date", null: false
    t.integer "log_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "batch_students", force: :cascade do |t|
    t.bigint "batch_id"
    t.bigint "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_students_on_batch_id"
    t.index ["student_id"], name: "index_batch_students_on_student_id"
  end

  create_table "batch_tests", force: :cascade do |t|
    t.bigint "batch_id"
    t.bigint "test_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_tests_on_batch_id"
    t.index ["test_id"], name: "index_batch_tests_on_test_id"
  end

  create_table "batches", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "client_name"
    t.string "branch_name"
    t.integer "code"
    t.string "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email", "subdomain"], name: "index_clients_on_email_and_subdomain", unique: true
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.date "event_date"
    t.boolean "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "student_id"
    t.string "name"
    t.string "mobile_number"
    t.string "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_feedbacks_on_student_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_notifications", force: :cascade do |t|
    t.bigint "students_id"
    t.bigint "notifications_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifications_id"], name: "index_student_notifications_on_notifications_id"
    t.index ["students_id"], name: "index_student_notifications_on_students_id"
  end

  create_table "students", force: :cascade do |t|
    t.integer "roll_number", null: false
    t.string "name", null: false
    t.string "mother_name", null: false
    t.date "date_of_birth"
    t.integer "gender", default: 0, null: false
    t.decimal "tenth_marks"
    t.string "contact"
    t.string "parent_mobile_number", null: false
    t.boolean "deleted"
    t.string "api_key", null: false
    t.integer "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notification_token"
  end

  create_table "test_students", force: :cascade do |t|
    t.bigint "test_id"
    t.bigint "student_id"
    t.integer "student_marks"
    t.string "student_answer_key"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_test_students_on_student_id"
    t.index ["test_id"], name: "index_test_students_on_test_id"
  end

  create_table "tests", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.date "test_date"
    t.integer "no_of_questions"
    t.integer "total_marks"
    t.integer "passing_marks"
    t.string "answer_key"
    t.boolean "is_theory", default: false, null: false
    t.boolean "is_combined", default: false, null: false
    t.string "question_paper_link"
    t.string "answer_paper_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
