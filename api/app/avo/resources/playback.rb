class Avo::Resources::Playback < Avo::BaseResource
  self.includes = [:user, :recording]

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :user, as: :belongs_to
    field :recording, as: :belongs_to
  end
end
