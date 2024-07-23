class Avo::Resources::RecordingSinger < Avo::BaseResource
  self.includes = [:recording, :person]
  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :recording, as: :belongs_to
    field :singer, as: :belongs_to, source: :person
  end
end
