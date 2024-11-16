class PlaylistType < ApplicationRecord
  attribute :name, :string

  has_many :playlists
end

# == Schema Information
#
# Table name: playlist_types
#
#  id   :uuid             not null, primary key
#  name :string           not null
#
