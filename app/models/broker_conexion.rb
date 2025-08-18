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

  scope :find_by_key_and_broker, ->(key, broker_name) {
    joins(:broker).find_by(key: key, brokers: { name: broker_name })
  }

  def expired?
    expires_at.present? && expires_at <= Time.now.utc
  end
end
