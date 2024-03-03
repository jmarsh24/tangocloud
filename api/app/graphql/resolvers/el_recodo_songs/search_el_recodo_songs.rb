module Resolvers::ElRecodoSongs
  class SearchElRecodoSongs < Resolvers::BaseResolver
    type Types::ElRecodoSongType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: nil)
      ElRecodoSong.search_el_recodo_songs(query)
    end
  end
end
