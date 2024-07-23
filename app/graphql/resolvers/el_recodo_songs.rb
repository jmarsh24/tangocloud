module Resolvers
  class ElRecodoSongs < BaseResolver
    type Types::ElRecodoSongType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      check_authentication!

      ElRecodoSong.search(query,
        fields: ["title^5", "composer", "author", "lyrics", "orchestra", "singer"],
        match: :word_start,
        misspellings: {below: 5}).results
    end
  end
end
