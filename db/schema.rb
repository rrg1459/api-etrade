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

ActiveRecord::Schema[7.2].define(version: 2025_08_14_235702) do
  create_table "brokers", force: :cascade do |t|
    t.string "nombre"
    t.string "direccion"
    t.string "contacto"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_brokers_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.date "date"
    t.time "hour"
    t.string "symbol"
    t.string "call_put"
    t.integer "spot_price"
    t.integer "strike_price"
    t.integer "distancia"
    t.integer "qty"
    t.integer "buy_price"
    t.integer "total_buy"
    t.integer "limit_price"
    t.date "date_sell"
    t.time "hour_sell"
    t.integer "sell_price"
    t.integer "total_sell"
    t.integer "gain_loss"
    t.integer "gain_loss_porcentual"
    t.integer "new_price"
    t.integer "new_price_porcentual"
    t.string "strategy"
    t.text "notes"
    t.integer "broker_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["broker_id"], name: "index_transactions_on_broker_id"
  end

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

  add_foreign_key "brokers", "users"
  add_foreign_key "transactions", "brokers"
end
