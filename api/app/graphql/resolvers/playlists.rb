module Resolvers
  class Playlists < BaseResolver
    type Types::PlaylistType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      ::Playlist.search(
        query,
        fields: [:title, :description],
        match: :word_middle,
        misspellings: {below: 5},
        order: {title: :asc},
        includes: [
          image_attachment: :blob
        ]
      ).results
    end
  end
end
