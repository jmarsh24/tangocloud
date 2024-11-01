class QueueItem < ApplicationRecord
  belongs_to :playback_queue
  belongs_to :item, polymorphic: true

  acts_as_list scope: :playback_queue

  validates :playback_queue, presence: true
  validates :item, presence: true
end

# == Schema Information
#
# Table name: queue_items
#
#  id                :uuid             not null, primary key
#  playback_queue_id :uuid             not null
#  item_type         :string           not null
#  item_id           :uuid             not null
#  position          :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
