class AddEtradeFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :etrade_request_token, :string
    add_column :users, :etrade_request_token_secret, :string
    add_column :users, :etrade_access_token, :string
    add_column :users, :etrade_access_secret, :string


    add_index :users, :etrade_request_token
    add_index :users, :etrade_access_token
  end
end
