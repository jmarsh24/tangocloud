module Resolvers
  class Recordings < BaseResolver
    type Types::RecordingType.connection_type, null: false

    argument :query, String, required: false, description: "Query to search for."
    argument :sort_by, String, required: false, description: "Field to sort by."
    argument :order, String, required: false, description: "Sort order, can be 'asc' or 'desc'."

    def resolve(query: nil, sort_by: nil, order: nil)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      if query.present?
        search_options = {
          fields: ["title^10", "orchestra_name", "singer_names", "genre", "year"],
          match: :word_start,
          misspellings: {below: 5},
          includes: [
            :orchestra,
            :singers,
            :recording_singers,
            :composition,
            :genre,
            :period,
            :lyrics,
            :audio_variants,
            audio_transfers: [album: {album_art_attachment: :blob}]
          ]
        }

        search_options[:order] = sort_by.present? ? {sort_by => order} : {listens_count: :desc}

        ::Recording.search(query, **search_options).results
      else
        recordings = ::Recording.all.includes(:orchestra, :singers, :recording_singers, :composition, :genre, :period, :lyrics, :audio_variants, audio_transfers: [album: {album_art_attachment: :blob}])

        sort_by.present? ? recordings.order(sort_by => order) : recordings.order(listens_count: :desc)
      end
    end
  end
end
