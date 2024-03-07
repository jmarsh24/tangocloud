module Types
  class PlayableType < Types::BaseUnion
    possible_types Types::RecordingType

    def self.resolve_type(object, context)
      if object.is_a?(Recording)
        Types::RecordingType
      else
        raise "Unknown playable type: #{object.class}"
      end
    end
  end
end
