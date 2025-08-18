# == Schema Information
#
# Table name: brokers
#
#  id           :integer          not null, primary key
#  api_base_url :string
#  contact      :string
#  email        :string
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Broker < ApplicationRecord
  has_many :broker_conexion_variables
  has_many :transactions
end
