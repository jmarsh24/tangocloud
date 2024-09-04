class PlaylistItem < ApplicationRecord
  belongs_to :playlist
  belongs_to :item, polymorphic: true
  belongs_to :recording, -> { where(item_type: "Recording") }, foreign_key: :item_id, optional: true, inverse_of: :playlist_items
  belongs_to :tanda, -> { where(item_type: "Tanda") }, foreign_key: :item_id, optional: true, inverse_of: :playlist_items

  acts_as_list scope: :playlist

  validates :playlist, presence: true
  validates :item, presence: true
  validates :item_type, presence: true, inclusion: {in: ["Recording", "Tanda"]}

  validates :position, presence: true, numericality: {only_integer: true}

  scope :ordered, -> { order(position: :asc) }
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
