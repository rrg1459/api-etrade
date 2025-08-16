class BrokerConexionVariable < ApplicationRecord
  belongs_to :broker

  has_one :user, through: :broker
end
