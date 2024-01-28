# frozen_string_literal: true

module Types
  class SearchResultType < Types::BaseObject
    field :songs, [Types::SongType], null: true
    field :artists, [Types::ArtistType], null: true
    field :albums, [Types::AlbumType], null: true
    field :playlists, [Types::PlaylistType], null: true
    field :total_results, Integer, null: true
    field :page_info, Types::PageInfoType, null: true
  end

  class SongType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :artist, Types::ArtistType, null: true
    field :album, Types::AlbumType, null: true
  end

  class ArtistType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :bio, String, null: true
    field :albums, [Types::AlbumType], null: true
  end

  class AlbumType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :artist, Types::ArtistType, null: true
    field :songs, [Types::SongType], null: true
  end

  class PlaylistType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :created_by, Types::UserType, null: true
    field :songs, [Types::SongType], null: true
  end

  class PageInfoType < Types::BaseObject
    field :has_next_page, Boolean, null: false
    field :has_previous_page, Boolean, null: false
    field :start_cursor, String, null: true
    field :end_cursor, String, null: true
  end

  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :username, String, null: false
  end
end
