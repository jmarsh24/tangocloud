module Types
  class OrderEnumType < Types::BaseEnum
    value "ASC", "Ascending order", value: "asc"
    value "DESC", "Descending order", value: "desc"
  end
end
