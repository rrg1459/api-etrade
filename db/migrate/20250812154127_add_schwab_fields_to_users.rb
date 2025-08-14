class AddSchwabFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :schwab_access_token, :string
    add_column :users, :schwab_refresh_token, :string
    add_column :users, :schwab_access_token_expires_at, :datetime
    add_column :users, :schwab_refresh_token_expires_at, :datetime
    add_column :users, :schwab_account_number, :integer
    add_column :users, :schwab_account_number_hash, :string
  end
end
