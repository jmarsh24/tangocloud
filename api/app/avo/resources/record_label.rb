class Avo::Resources::RecordLabel < Avo::BaseResource
  self.includes = [:recordings]

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :name, as: :text, required: true
    field :description, as: :textarea
    field :founded_date, as: :date
    field :bio, as: :trix
    field :recordings, as: :has_many
  end
end
