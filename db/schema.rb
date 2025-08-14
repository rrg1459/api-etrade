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

ActiveRecord::Schema[7.2].define(version: 2025_08_12_154127) do
  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "etrade_request_token"
    t.string "etrade_request_token_secret"
    t.string "etrade_access_token"
    t.string "etrade_access_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "schwab_access_token"
    t.string "schwab_refresh_token"
    t.datetime "schwab_access_token_expires_at"
    t.datetime "schwab_refresh_token_expires_at"
    t.integer "schwab_account_number"
    t.string "schwab_account_number_hash"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["etrade_access_token"], name: "index_users_on_etrade_access_token"
    t.index ["etrade_request_token"], name: "index_users_on_etrade_request_token"
  end
end
