module Types
  class ValidationErrorType < Types::BaseObject
    class AttributeError < Types::BaseObject
      field :attribute, String, null: false
      field :errors, [String], null: false

      def errors
        object[:errors].map(&:message)
      end
    end

    class Errors < Types::BaseObject
      field :attribute_errors, [AttributeError], null: false
      field :full_messages, [String], null: false

      def attribute_errors
        object.group_by_attribute.map do |attribute, errors|
          {
            attribute:,
            errors:
          }
        end
      end
    end

    field :errors, Types::ValidationErrorType::Errors, null: false
  end
end
