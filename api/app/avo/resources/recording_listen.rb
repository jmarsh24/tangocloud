class Avo::Resources::RecordingListen < Avo::BaseResource
  self.includes = []

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :recording, as: :belongs_to
  end
end
