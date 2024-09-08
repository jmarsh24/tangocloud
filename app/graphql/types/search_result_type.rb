module Types
  class SearchResultType < Types::BaseUnion
    description "Search result"

    possible_types Types::RecordingType,
      Types::OrchestraType,
      Types::PlaylistType,
      Types::GenreType,
      Types::TandaType

    def self.resolve_type(object, context)
      case object
      when Recording
        Types::RecordingType
      when Orchestra
        Types::OrchestraType
      when Playlist
        Types::PlaylistType
      when Genre
        Types::GenreType
      when Tanda
        Types::TandaType
      else
        raise "Unexpected search result: #{object}"
      end
    end
  end
end
