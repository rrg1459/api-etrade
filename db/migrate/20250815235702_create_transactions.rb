class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.date :date
      t.time :hour
      t.string :call_put
      t.integer :spot_price
      t.integer :strike_price
      t.integer :distance
      t.integer :qty
      t.integer :buy_price
      t.integer :total_buy
      t.integer :limit_price
      t.date :date_sell
      t.time :hour_sell
      t.integer :sell_price
      t.integer :total_sell
      t.integer :gain_loss
      t.integer :gain_loss_porcentual
      t.integer :new_price
      t.integer :new_price_porcentual
      t.string :notes
      t.references :broker, null: false, foreign_key: true
      t.references :strategy, null: false, foreign_key: true
      t.references :symbol, null: false, foreign_key: true

      t.timestamps
    end
  end
end
