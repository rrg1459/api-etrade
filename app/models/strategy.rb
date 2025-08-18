# == Schema Information
#
# Table name: strategies
#
#  id            :integer          not null, primary key
#  analysis_type :string
#  description   :string
#  ideal_for     :string
#  name          :string
#  time_frame    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Strategy < ApplicationRecord
  has_many :transactions
end
