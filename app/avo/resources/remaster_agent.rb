class Avo::Resources::RemasterAgent < Avo::BaseResource
  self.includes = [:digital_remasters]

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :name, as: :text, required: true
    field :description, as: :textarea
    field :digital_remasters, as: :has_many
  end
end
