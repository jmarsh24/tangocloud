module Types
  class ItemType < Types::BaseUnion
    possible_types Types::RecordingType

    def self.resolve_type(object, context)
      if object.is_a?(Recording)
        Types::RecordingType
      elsif object.is_a?(Tanda)
        Types::TandaType
      else
        raise "Unknown Item type: #{object.class}"
      end
    end
  end
end
