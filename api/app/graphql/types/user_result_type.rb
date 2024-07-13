module Types
  class UserResultType < BaseUnion
    possible_types Types::UserType, Types::ValidationErrorType

    def self.resolve_type(object, context)
      if object.success?
        [Types::UserType, object.success]
      else
        [Types::ValidationErrorType, object.failure]
      end
    end
  end
end
