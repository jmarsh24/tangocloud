module Resolvers
  class Recordings < BaseResolver
    type Types::RecordingType.connection_type, null: false

    argument :query, String, required: false, description: "Query to search for."
    argument :sort_by, String, required: false, description: "Field to sort by."
    argument :order, String, required: false, description: "Sort order, can be 'asc' or 'desc'."

    def resolve(query: nil, sort_by: nil, order: nil)
      check_authentication!

      search_options = {
        fields: ["title^10", "orchestra_name", "singer_names", "genre", "year"],
        match: :word_start,
        misspellings: {below: 5}
      }

      # search_options[:order] = sort_by.present? ? {sort_by => order} : {playbacks_count: :desc}

      ::Recording.search(query, **search_options).results
    end
  end
end
