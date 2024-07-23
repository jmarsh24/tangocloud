module Types
  class RecordingOrderByInputType < Types::BaseInputObject
    argument :field, Types::RecordingOrderFieldEnumType, required: true, description: "Field to sort by."
    argument :order, Types::OrderEnumType, required: true, description: "Sort order, can be 'asc' or 'desc'."
  end
end
