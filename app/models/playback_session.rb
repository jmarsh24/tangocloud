class PlaybackSession < ApplicationRecord
  belongs_to :user
  belongs_to :current_item, class_name: "QueueItem", optional: true

  validates :user, presence: true
  attribute :volume, :integer, default: 100
  attribute :muted, :boolean, default: false
  attribute :playing, :boolean, default: false
  attribute :position, :integer, default: 0

  def play(reset_position: false)
    update!(playing: true, position: reset_position ? 0 : position)
  end

  def pause
    update!(playing: false)
  end

  def seek(position)
    update!(position:)
  end

  def volume=(new_volume)
    super(new_volume.clamp(0, 100))
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
#  volume     :integer          default(100)
#  muted      :boolean          default(FALSE)
#
