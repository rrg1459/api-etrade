class Transaction < ApplicationRecord
  belongs_to :broker
  belongs_to :strategy
  belongs_to :symbol

  has_one :user, through: :broker
end
