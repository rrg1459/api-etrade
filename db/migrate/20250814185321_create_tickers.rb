class CreateTickers < ActiveRecord::Migration[7.2]
  def change
    create_table :tickers do |t|
      t.string :name
      t.string :asset
      t.string :asset_type
      t.string :market

      t.timestamps
    end
  end
end
