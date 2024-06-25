class Listen < ApplicationRecord
  belongs_to :user
  belongs_to :recording, counter_cache: true

  scope :most_recent, -> { order(created_at: :desc) }
end

# == Schema Information
#
# Table name: playbacks
#
#  id           :uuid             not null, primary key
#  user_id      :uuid             not null
#  recording_id :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
