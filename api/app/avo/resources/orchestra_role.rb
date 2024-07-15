class Avo::Resources::OrchestraRole < Avo::BaseResource
  self.includes = [:orchestra, :role, :person]

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :orchestra, as: :belongs_to
    field :role, as: :belongs_to
    field :person, as: :belongs_to
  end
end
