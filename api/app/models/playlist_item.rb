class PlaylistItem < ApplicationRecord
  belongs_to :playlist, counter_cache: true, touch: true
  belongs_to :playable, polymorphic: true

  acts_as_list scope: :playlist

  validates :position, presence: true, numericality: {only_integer: true}
end

# == Schema Information
#
# Table name: playlist_items
#
#  id            :uuid             not null, primary key
#  playlist_id   :uuid             not null
#  playable_type :string           not null
#  playable_id   :uuid             not null
#  position      :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
