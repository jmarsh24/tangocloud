class Avo::Resources::TandaRecording < Avo::BaseResource
  self.includes = [:tanda, :recording]
  def fields
    field :id, hide_on: :index
    field :position, as: :number
    field :tanda, as: :belongs_to
    field :recording, as: :belongs_to
  end
end
