class UserPreference < ApplicationRecord
  belongs_to :user

  has_one_attached :avatar

  def name
    "#{first_name} #{last_name}"
  end
end

# == Schema Information
#
# Table name: user_preferences
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
