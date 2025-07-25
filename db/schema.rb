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

ActiveRecord::Schema[8.0].define(version: 2025_07_22_224313) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "debts", force: :cascade do |t|
    t.string "name"
    t.string "government_id"
    t.decimal "debt_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paid_status", default: false, null: false
    t.datetime "paid_at"
    t.string "paid_by"
    t.string "email"
    t.string "debt_id"
    t.date "debt_due_date", null: false
    t.index ["debt_id"], name: "index_debts_on_debt_id", unique: true
  end
end
