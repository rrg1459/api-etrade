# == Schema Information
#
# Table name: broker_conexions
#
#  id          :integer          not null, primary key
#  description :string
#  expires_at  :datetime
#  key         :string
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  broker_id   :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_broker_conexions_on_broker_id  (broker_id)
#  index_broker_conexions_on_user_id    (user_id)
#
# Foreign Keys
#
#  broker_id  (broker_id => brokers.id)
#  user_id    (user_id => users.id)
#


class BrokerConexion < ApplicationRecord
  belongs_to :broker
  belongs_to :user

  # https://gemini.google.com/app/aa713f8928d59fde

  # has_one :user, through: :broker

  # def self.schwab_token_is_valid?
  #   byebug
  #   data['schwab_access_token'].present? && data['schwab_access_token_expires_at'].present? && Time.parse(data['schwab_access_token_expires_at']) > Time.now.utc
  # end

  def expired?
    expires_at.present? && expires_at <= Time.now.utc
  end

  # def valid?
  #   # !expired?
  #   expires_at.present? && expires_at > Time.now.utc
  # end

  # # Los siguientes métodos no son estrictamente necesarios, pero mejoran la legibilidad
  # def schwab_access_token
  #   value if key == 'access_token' && broker_id == 2
  # end

  # def schwab_refresh_token
  #   value if key == 'refresh_token' && broker_id == 2
  # end
end
