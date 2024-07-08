class Avo::Resources::Tag < Avo::BaseResource
  self.title = :name
  self.includes = [:taggings]

  def fields
    field :id, as: :id
    field :name, as: :text
    field :taggings, as: :has_many
    field :created_at, as: :date, readonly: true
  end
end
