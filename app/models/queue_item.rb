class QueueItem < ApplicationRecord
  include RankedModel

  belongs_to :playback_queue
  belongs_to :item, polymorphic: true

  ranks :row_order, with_same: :playback_queue_id

  validates :playback_queue, presence: true
  validates :item, presence: true
  validates :item_type, presence: true

  scope :including_item_associations, -> {
    includes(
      item: [
        :composition,
        :orchestra,
        :genre,
        :singers,
        digital_remasters: [
          audio_variants: {audio_file_attachment: :blob},
          album: {album_art_attachment: :blob}
        ],
        waveforms: [:waveform_datum]
      ]
    )
  }
end

# == Schema Information
#
# Table name: queue_items
#
#  id                :uuid             not null, primary key
#  playback_queue_id :uuid             not null
#  item_type         :string           not null
#  item_id           :uuid             not null
#  row_order         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
