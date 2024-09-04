module Types
  class BaseObject < GraphQL::Schema::Object
    include Authenticating
    include FieldDescribing

    # class UnauthorizedError < GraphQL::ExecutionError
    #   def initialize
    #     super("You are not authorized to perform this action, please contact an administrator.")
    #   end
    # end

    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField

    # class << self
    #   def authorized?(object, context)
    #     current_user = context[:current_user]
    #     (current_user&.admin? || current_user&.approved?) || raise(UnauthorizedError)
    #   end
    # end
  end
end
