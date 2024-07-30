module Types
  class SingerType < Types::PersonType
    has_many :compositions

    has_one_attached :image
  end
end
