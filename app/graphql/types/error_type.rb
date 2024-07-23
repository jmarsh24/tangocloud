module Types
  class ErrorType < Types::BaseObject
    description "Represents an error"

    field :message, String, null: false,
      description: "A description of the error"

    field :code, String, null: true,
      description: "A unique error code"

    field :path, [String], null: true,
      description: "The path to the field that caused the error"
  end
end
