module Resolvers::ElRecodoSongs
  class SearchElRecodoSongs < Resolvers::BaseResolver
    type Types::ElRecodoSongType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      ElRecodoSong.search_songs(query).results
    end
  end
end
