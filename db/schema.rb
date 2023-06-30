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

ActiveRecord::Schema[7.0].define(version: 2023_06_30_150957) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "amount"
    t.integer "status", default: 0
    t.citext "customer_email"
    t.citext "customer_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.uuid "merchant_id"
    t.uuid "reference_id"
    t.index ["merchant_id"], name: "index_transactions_on_merchant_id"
    t.index ["reference_id"], name: "index_transactions_on_reference_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name", null: false
    t.text "description", null: false
    t.citext "email", null: false
    t.boolean "active", default: true, null: false
    t.integer "total_transaction_sum", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "password_digest", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "transactions", "transactions", column: "reference_id"
end
