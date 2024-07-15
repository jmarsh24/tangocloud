module Types
  class RefreshResultType < BaseUnion
    possible_types Types::SessionType, Types::FailedRefreshType

    def self.resolve_type(object, context)
      if object.success?
        [Types::SessionType, object.success]
      else
        Types::FailedRefreshType
      end
    end
  end
end
