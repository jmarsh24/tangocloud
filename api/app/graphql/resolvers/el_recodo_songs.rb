module Resolvers
  class ElRecodoSongs < BaseResolver
    type Types::ElRecodoSongType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      ElRecodoSong.search(query,
        fields: ["title^5", "composer", "author", "lyrics", "orchestra", "singer"],
        match: :word_middle,
        misspellings: {below: 5}).results
    end
  end
end
