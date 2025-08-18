class CreateBrokers < ActiveRecord::Migration[7.2]
  def change
    create_table :brokers do |t|
      t.string :name
      t.string :api_base_url
      t.string :email
      t.string :contact

      t.timestamps
    end
  end
end
