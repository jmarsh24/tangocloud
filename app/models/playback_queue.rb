class PlaybackQueue < ApplicationRecord
  belongs_to :user

  has_many :queue_items, dependent: :destroy
  has_many :recordings, through: :queue_items, source: :item, source_type: "Recording"
  has_many :tandas, through: :queue_items, source: :item, source_type: "Tanda"

  validates :user, presence: true

  belongs_to :current_item, class_name: "QueueItem", optional: true

  attribute :playing, :boolean, default: false
  attribute :progress, :integer, default: 0
end

# == Schema Information
#
# Table name: playback_queues
#
#  id              :uuid             not null, primary key
#  user_id         :uuid             not null
#  playing         :boolean          default(FALSE), not null
#  progress        :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  current_item_id :uuid
#
