class QueueItem < ApplicationRecord
  include RankedModel

  belongs_to :playback_queue, touch: true
  belongs_to :item, polymorphic: true
  belongs_to :tanda, optional: true

  enum :section, {now_playing: "now_playing", next_up: "next_up", auto_queue: "auto_queue", played: "played"}

  validates :item_type, inclusion: {in: %w[Tanda Recording]}

  ranks :row_order, with_same: [:playback_queue_id, :section]

  scope :now_playing, -> { where(section: :now_playing) }
  scope :next_up, -> { where(section: :next_up) }
  scope :auto_queue, -> { where(section: :auto_queue) }
  scope :played, -> { where(section: :played) }
  scope :active_item, -> { where(active: true) }
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
#  section           :enum             default("next_up")
#  active            :boolean          default(FALSE), not null
#  tanda_id          :uuid
#
