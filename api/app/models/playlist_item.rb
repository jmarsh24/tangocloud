class PlaylistItem < ApplicationRecord
  belongs_to :playlist
  belongs_to :item, polymorphic: true

  acts_as_list scope: :playlist

  validates :playlist, presence: true
  validates :item, presence: true

  validates :position, presence: true, numericality: {only_integer: true}
end

# == Schema Information
#
# Table name: playlist_items
#
#  id          :uuid             not null, primary key
#  playlist_id :uuid             not null
#  item_type   :string           not null
#  item_id     :bigint           not null
#  position    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
