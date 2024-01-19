# frozen_string_literal: true

# == Schema Information
#
# Table name: subscriptions
#
#  id                  :uuid             not null, primary key
#  name                :string           default(""), not null
#  description         :string
#  type                :integer          default("free"), not null
#  start_date          :datetime         not null
#  end_date            :datetime         not null
#  action_auth_user_id :uuid
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Subscription < ApplicationRecord
  belongs_to :action_auth_user, class_name: "User", foreign_key: "action_auth_user_id"

  validates :name, presence: true
  validates :type, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :action_auth_user_id, presence: true
  validates :type, inclusion: {in: ["free", "premium", "hifi"]}
  enum type: {free: 0, premium: 1, hifi: 2}
end
