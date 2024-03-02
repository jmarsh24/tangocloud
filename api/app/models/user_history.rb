class UserHistory < ApplicationRecord
  belongs_to :user
  has_many :listens, class_name: "RecordingListen", dependent: :destroy
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
