module Types
  class OrderByInputType < Types::BaseInputObject
    argument :field, String, required: true, description: "Field to sort by."
    argument :order, String, required: true, description: "Sort order, can be 'asc' or 'desc'."
  end
end
