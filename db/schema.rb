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

ActiveRecord::Schema[7.2].define(version: 2025_08_15_235702) do
  create_table "broker_conexion_variables", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "value"
    t.datetime "expires_at"
    t.integer "user_id", null: false
    t.integer "broker_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["broker_id"], name: "index_broker_conexion_variables_on_broker_id"
    t.index ["user_id"], name: "index_broker_conexion_variables_on_user_id"
  end

  create_table "brokers", force: :cascade do |t|
    t.string "name"
    t.string "api_url"
    t.string "email"
    t.string "contact"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_brokers_on_user_id"
  end

  create_table "strategies", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "symbols", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.date "date"
    t.time "hour"
    t.string "call_put"
    t.integer "spot_price"
    t.integer "strike_price"
    t.integer "distance"
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
    t.string "notes"
    t.integer "broker_id", null: false
    t.integer "strategy_id", null: false
    t.integer "symbol_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["broker_id"], name: "index_transactions_on_broker_id"
    t.index ["strategy_id"], name: "index_transactions_on_strategy_id"
    t.index ["symbol_id"], name: "index_transactions_on_symbol_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "broker_conexion_variables", "brokers"
  add_foreign_key "broker_conexion_variables", "users"
  add_foreign_key "brokers", "users"
  add_foreign_key "transactions", "brokers"
  add_foreign_key "transactions", "strategies"
  add_foreign_key "transactions", "symbols"
end
