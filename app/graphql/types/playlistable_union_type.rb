module Types
  class PlaylistableUnionType < Types::BaseUnion
    description "Objects which can be a playlistable type, either Playlist or Tanda"

    possible_types Types::PlaylistType, Types::TandaType

    def self.resolve_type(object, _context)
      if object.is_a?(Playlist)
        Types::PlaylistType
      elsif object.is_a?(Tanda)
        Types::TandaType
      else
        raise "Unexpected playlistable type: #{object.class}"
      end
    end
  end
end
