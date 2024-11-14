class PlaylistItem < ApplicationRecord
  belongs_to :playlist
  belongs_to :item, polymorphic: true

  acts_as_list scope: :playlist

  validates :position, presence: true, numericality: {only_integer: true}

  scope :ordered, -> { order(position: :asc) }

  counter_culture(
    [:item],
    column_name: "playlists_count"
  )
end

# == Schema Information
#
# Table name: playlist_items
#
#  id          :uuid             not null, primary key
#  playlist_id :uuid             not null
#  item_type   :string           not null
#  item_id     :uuid             not null
#  position    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
