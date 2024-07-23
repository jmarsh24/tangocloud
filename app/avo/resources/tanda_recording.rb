class Avo::Resources::TandaRecording < Avo::BaseResource
  self.includes = []

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :position, as: :number
    field :tanda, as: :belongs_to
    field :recording, as: :belongs_to
  end
end
