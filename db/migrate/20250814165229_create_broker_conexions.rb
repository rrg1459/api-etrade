class CreateBrokerConexions < ActiveRecord::Migration[7.2]
  def change
    create_table :broker_conexions do |t|
      t.references :broker, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :key
      t.string :value
      t.string :description
      t.datetime :expires_at

      t.timestamps
    end
  end
end
