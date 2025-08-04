class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.string :etrade_request_token
      t.string :etrade_request_token_secret

      t.string :etrade_access_token
      t.string :etrade_access_secret

      t.timestamps
    end

    add_index :users, :email, unique: true

    add_index :users, :etrade_request_token
    add_index :users, :etrade_access_token
  end
end