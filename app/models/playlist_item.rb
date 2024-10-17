class PlaylistItem < ApplicationRecord
  belongs_to :playlistable, polymorphic: true
  belongs_to :item, polymorphic: true

  acts_as_list scope: :playlistable

  validates :item, presence: true
  validates :item_type, presence: true, inclusion: {in: ["Recording", "Tanda"]}
  validates :playlistable, presence: true
  validates :playlistable_type, presence: true, inclusion: {in: ["Playlist", "Tanda"]}

  validates :position, presence: true, numericality: {only_integer: true}

  scope :ordered, -> { order(position: :asc) }
end

# == Schema Information
#
# Table name: playlist_items
#
#  id                :integer          not null, primary key
#  playlistable_type :string           not null
#  playlistable_id   :integer          not null
#  item_type         :string           not null
#  item_id           :integer          not null
#  position          :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
