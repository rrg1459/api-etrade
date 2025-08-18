# == Schema Information
#
# Table name: transactions
#
#  id                   :integer          not null, primary key
#  buy_price            :integer
#  call_put             :string
#  date                 :date
#  date_sell            :date
#  distance             :integer
#  gain_loss            :integer
#  gain_loss_porcentual :integer
#  hour                 :time
#  hour_sell            :time
#  limit_price          :integer
#  new_price            :integer
#  new_price_porcentual :integer
#  notes                :string
#  qty                  :integer
#  sell_price           :integer
#  spot_price           :integer
#  strike_price         :integer
#  total_buy            :integer
#  total_sell           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  broker_id            :integer          not null
#  strategy_id          :integer          not null
#  ticker_id            :integer          not null
#  user_id              :integer          not null
#
# Indexes
#
#  index_transactions_on_broker_id    (broker_id)
#  index_transactions_on_strategy_id  (strategy_id)
#  index_transactions_on_ticker_id    (ticker_id)
#  index_transactions_on_user_id      (user_id)
#
# Foreign Keys
#
#  broker_id    (broker_id => brokers.id)
#  strategy_id  (strategy_id => strategies.id)
#  ticker_id    (ticker_id => tickers.id)
#  user_id      (user_id => users.id)
#
class Transaction < ApplicationRecord
  belongs_to :broker
  belongs_to :user
  belongs_to :strategy
  belongs_to :ticker

  # has_one :user, through: :broker

  # transactions = Transaction.by_broker_and_user(2, 1)
  scope :by_broker_and_user, ->(broker_id, user_id) {
    where(broker_id: broker_id, user_id: user_id)
  }

  # scope :by_broker_and_user, ->(broker_id, user_id) {
  #   joins(:broker).where(brokers: { id: broker_id, user_id: user_id })
  # }

end
