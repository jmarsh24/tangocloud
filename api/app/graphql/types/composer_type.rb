module Types
  class ComposerType < Types::PersonType
    has_many :compositions
  end
end
