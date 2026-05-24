# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_24_105735) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.datetime "check_in_at"
    t.datetime "check_out_at"
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.decimal "overtime_hours"
    t.datetime "updated_at", null: false
    t.date "work_date"
    t.index ["employee_id", "work_date"], name: "index_attendances_on_employee_id_and_work_date", unique: true
    t.index ["employee_id"], name: "index_attendances_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "position"
    t.decimal "salary", precision: 20, scale: 2
    t.datetime "updated_at", null: false
  end

  add_foreign_key "attendances", "employees"
end
