class CreateBrokers < ActiveRecord::Migration[7.2]
  def change
    create_table :brokers do |t|
      t.string :name
      t.string :api_url
      t.string :email
      t.string :contact
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
