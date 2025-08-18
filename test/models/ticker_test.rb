# == Schema Information
#
# Table name: tickers
#
#  id         :integer          not null, primary key
#  asset      :string
#  asset_type :string
#  market     :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class TickerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
