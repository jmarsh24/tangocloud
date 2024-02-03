module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :search_recordings, [Types::RecordingType], null: false, description: "Search for recordings." do
      argument :query, String, required: true, description: "Query to search for."
      argument :page, Integer, required: false, description: "Page number."
      argument :per_page, Integer, required: false, description: "Number of results per page."
    end

    def search_recordings(query:, page: 1, per_page: 10)
      Recording.search_recordings(query, page:, per_page:).results
    end

    field :search_el_recodo_songs, [Types::ElRecodoSongType], null: false do
      argument :query, String, required: true, description: "Query to search for."
      argument :page, Integer, required: false, description: "Page number."
      argument :per_page, Integer, required: false, description: "Number of results per page."
    end

    def search_el_recodo_songs(query:)
      ElRecodoSong.search_songs(query).results
    end

    field :who_am_i, String, null: false,
      description: "Who am I"
    def who_am_i
      "You've authenticated as #{context[:current_user].presence || "guest"}."
    end
  end
end
