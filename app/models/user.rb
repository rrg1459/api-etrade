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

  # Delegate method for schwab token is valid
  def schwab_access_token_is_valid?
    access_token = broker_conexions.find_by_key_and_broker('access_token', 'schwab')

    access_token.present? && !access_token.expired?
  end

  # Delegate method for schwab refresh token is valid
  def schwab_refresh_token_is_valid?
    conexion = broker_conexions.find_by_key_and_broker('refresh_token', 'schwab')

    conexion.present? && !conexion.expired?
  end

  # Delegate method for schwab number hash
  def schwab_account_number_hash
    conexion = broker_conexions.find_by_key_and_broker('account_number_hash', 'schwab')

    conexion.value if conexion.present?
  end

  # Delegate method for schwab access token
  def schwab_access_token
    conexion = broker_conexions.find_by_key_and_broker('access_token', 'schwab')

    conexion.value if conexion.present?
  end

  # Delegate method for schwab refresh token
  def schwab_refresh_token
    conexion = broker_conexions.find_by_key_and_broker('refresh_token', 'schwab')

    conexion.value if conexion.present?
  end
end
