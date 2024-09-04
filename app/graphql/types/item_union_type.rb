module Types
  class ItemUnionType < Types::BaseUnion
    description "Objects which can be an item type, either Recording or Tanda"

    possible_types Types::RecordingType, Types::TandaType

    def self.resolve_type(object, _context)
      if object.is_a?(Recording)
        Types::RecordingType
      elsif object.is_a?(Tanda)
        Types::TandaType
      else
        raise "Unexpected item type: #{object.class}"
      end
    end
  end
end
