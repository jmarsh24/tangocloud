class PlaybackSession < ApplicationRecord
  belongs_to :user
  belongs_to :current_item, class_name: "QueueItem", optional: true

  validates :user, presence: true

  def play
    update!(playing: true)
  end

  def pause
    update!(playing: false)
  end

  def seek(position)
    update!(position: position)
  end
end

# == Schema Information
#
# Table name: playback_sessions
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  playing    :boolean          default(FALSE), not null
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#