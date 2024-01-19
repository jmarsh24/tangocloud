# frozen_string_literal: true

# == Schema Information
#
# Table name: subscriptions
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  type        :integer          default("free"), not null
#  start_date  :datetime         not null
#  end_date    :datetime         not null
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Subscription < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :type, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :user_id, presence: true
  validates :type, inclusion: {in: ["free", "premium", "hifi"]}
  enum type: {free: 0, premium: 1, hifi: 2}
end
