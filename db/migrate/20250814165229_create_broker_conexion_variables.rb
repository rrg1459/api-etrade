class CreateBrokerConexionVariables < ActiveRecord::Migration[7.2]
  def change
    create_table :broker_conexion_variables do |t|
      t.string :name
      t.string :description
      t.string :value
      t.datetime :expires_at
      t.references :user, null: false, foreign_key: true
      t.references :broker, null: false, foreign_key: true

      t.timestamps
    end
  end
end
