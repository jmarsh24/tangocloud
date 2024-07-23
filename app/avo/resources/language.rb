class Avo::Resources::Language < Avo::BaseResource
  self.includes = [:lyrics]

  def fields
    field :id, as: :id
    field :name, as: :text
    field :lyrics, as: :has_many
  end
end
