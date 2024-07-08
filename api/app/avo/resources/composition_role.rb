class Avo::Resources::CompositionRole < Avo::BaseResource
  self.includes = [:person, :composition]

  def fields
    field :id, as: :id
    field :role, as: :select, options: { composer: "composer", lyricist: "lyricist" }
    field :person, as: :belongs_to
    field :composition, as: :belongs_to
  end
end
