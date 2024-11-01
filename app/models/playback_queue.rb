class PlaybackQueue < ApplicationRecord
  belongs_to :user

  has_many :queue_items, dependent: :destroy
  has_many :recordings, through: :queue_items, source: :item, source_type: "Recording"
  has_many :tandas, through: :queue_items, source: :item, source_type: "Tanda"

  validates :user, presence: true

  belongs_to :current_item, class_name: "QueueItem", optional: true

  attribute :is_playing, :boolean, default: false
  attribute :progress, :integer, default: 0
end