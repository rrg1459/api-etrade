class User < ApplicationRecord
  # ... otras validaciones y relaciones

  # def schwab_token_is_valid?
  #   schwab_access_token.present? && schwab_access_token_expires_at.present? && schwab_access_token_expires_at > Time.now.utc
  # end

  # def schwab_refresh_token_is_valid?
  #   schwab_refresh_token.present? && schwab_refresh_token_expires_at.present? && schwab_refresh_token_expires_at > Time.now.utc
  # end

  has_many :brokers

  has_many :transactions, through: :brokers
  has_many :broker_conexion_variables, through: :brokers
end
