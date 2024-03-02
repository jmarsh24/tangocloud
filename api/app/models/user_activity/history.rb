class UserActivity::History < ApplicationRecord
  self.table_name = "histories"
  belongs_to :user
  has_many :listens, class_name: "UserActivity::Listen", dependent: :destroy
end

# == Schema Information
#
# Table name: histories
#
#  id         :uuid             not null, primary key
#  user_id    :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
