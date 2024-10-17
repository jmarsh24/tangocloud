class Playback < ApplicationRecord
  belongs_to :user
  belongs_to :recording, counter_cache: true

  scope :most_recent, -> { order(created_at: :desc) }
end

# == Schema Information
#
# Table name: playbacks
#
#  id           :integer          not null, primary key
#  duration     :integer          default(0), not null
#  user_id      :integer          not null
#  recording_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
