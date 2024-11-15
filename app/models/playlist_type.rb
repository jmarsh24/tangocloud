class PlaylistType < ApplicationRecord
  attribute :name, :string

  has_many :playlists
end