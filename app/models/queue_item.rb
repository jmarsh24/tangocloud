class QueueItem < ApplicationRecord
  belongs_to :playback_queue
  belongs_to :item, polymorphic: true

  acts_as_list scope: :playback_queue

  validates :playback_queue, presence: true
  validates :item, presence: true
end
