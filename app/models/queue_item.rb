class QueueItem < ApplicationRecord
  include RankedModel

  belongs_to :playback_queue, touch: true
  belongs_to :item, polymorphic: true

  enum :source, {next_up: "next_up", auto_queue: "auto_queue"}

  validates :item_type, inclusion: {in: %w[Playlist Tanda Recording]}

  ranks :row_order, with_same: :playback_queue_id

  scope :next_up, -> { where(source: :next_up) }
  scope :auto_queue, -> { where(source: :auto_queue) }
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
#  source            :enum             default("next_up")
#
