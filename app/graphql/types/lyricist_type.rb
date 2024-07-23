module Types
  class LyricistType < Types::PersonType
    has_many :compositions
  end
end
