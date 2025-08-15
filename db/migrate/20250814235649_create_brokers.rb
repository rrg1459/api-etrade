class CreateBrokers < ActiveRecord::Migration[7.2]
  def change
    create_table :brokers do |t|
      t.string :nombre
      t.string :direccion
      t.string :contacto
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
