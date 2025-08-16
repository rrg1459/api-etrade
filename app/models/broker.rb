class Broker < ApplicationRecord
  belongs_to :user
  has_many :broker_conexion_variables
  has_many :transactions
end
