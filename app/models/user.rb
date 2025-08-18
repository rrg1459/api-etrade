# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_many :brokers
  has_many :transactions
  has_many :broker_conexions

  # Delegate method for schwab  token is valid
  def schwab_token_is_valid?access
    access_token = broker_conexions.find_by(key: 'access_token', broker_id: 2)

    access_token.present? && !access_token.expired?
  end

  # Delegate method for schwab refresh token is valid
  def schwab_refresh_token_is_valid?
    refresh_token_conn = broker_conexions.find_by(key: 'refresh_token', broker_id: 2)

    refresh_token_conn.present? && !refresh_token_conn.expired?
  end

  # Delegate method for schwab number hash
  def schwab_account_number_hash
    conexion = broker_conexions.find_by(key: 'account_number_hash', broker_id: 2)
    conexion.value if conexion.present?
  end

  # Delegate method for schwab access token
  def schwab_access_token
    conexion = broker_conexions.find_by(key: 'access_token', broker_id: 2)
    conexion.value if conexion.present?
  end

  # Delegate method for schwab refresh token
  def schwab_refresh_token
    conexion = broker_conexions.find_by(key: 'refresh_token', broker_id: 2)
    conexion.value if conexion.present?
  end
end
