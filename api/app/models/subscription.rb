class Subscription < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :type, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :user_id, presence: true
  enum subscription_type: {free: "free", premium: "premium", hifi: "hifi"}
end

# == Schema Information
#
# Table name: subscriptions
#
#  id                :uuid             not null, primary key
#  name              :string           not null
#  description       :string
#  type              :integer          default(0), not null
#  start_date        :datetime         not null
#  end_date          :datetime         not null
#  subscription_type :enum             default("free"), not null
#  user_id           :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
