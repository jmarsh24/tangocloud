# frozen_string_literal: true

# == Schema Information
#
# Table name: user_settings
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  admin      :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserSetting < ApplicationRecord
  belongs_to :user

  validates :admin, presence: true
  validates :user_id, presence: true
  validates :user_id, uniqueness: true
  validates :admin, inclusion: {in: [true, false]}
end
