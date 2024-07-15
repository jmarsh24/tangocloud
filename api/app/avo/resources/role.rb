class Avo::Resources::Role < Avo::BaseResource
  self.includes = [:orchestra_roles]

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :name, as: :text, required: true
    field :orchestra_roles, as: :has_many
  end
end
