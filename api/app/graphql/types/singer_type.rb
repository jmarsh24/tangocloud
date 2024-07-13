module Types
  class SingerType < Types::PersonType
    has_many :compositions
  end
end
