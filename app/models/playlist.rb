class Playlist < ApplicationRecord
  include Playlistable

  has_many :playlist_items, dependent: :destroy
  has_many :tanda_items, through: :playlist_items, source: :item, source_type: "TandaItem", dependent: :destroy
  has_many :recordings, through: :playlist_items, source: :item, source_type: "Recording"
  has_many :tandas, through: :playlist_items, source: :item, source_type: "Tanda"

  belongs_to :playlist_type, optional: true
end

# == Schema Information
#
# Table name: playlists
#
#  id               :uuid             not null, primary key
#  title            :string           not null
#  subtitle         :string
#  description      :text
#  slug             :string
#  public           :boolean          default(TRUE), not null
#  user_id          :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  playlist_type_id :uuid
#  import_as_tandas :boolean          default(FALSE), not null
#
