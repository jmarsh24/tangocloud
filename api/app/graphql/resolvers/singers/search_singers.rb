module Resolvers::Singers
  class SearchSingers < Resolvers::BaseResolver
    type Types::SingerType.connection_type, null: false

    argument :query, String, required: false, description: "Name of the singer."

    def resolve(query: "*")
      Singer.search(query,
        fields: [
          "filename",
          "album",
          "recording",
          "orchestra_name",
          "singer_names",
          "genre",
          "period",
          "transfer_agent",
          "audio_variants"
        ],
        includes: [:album, :transfer_agent, recording: [:orchestra, :singers, :genre, :period, composition: [:composer, :lyricist]]],
        match: :word_middle,
        misspellings: {below: 5}).results
    end
  end
end
