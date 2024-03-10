class Avo::Resources::PlaybackHistory < Avo::BaseResource
  self.includes = []

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :playbacks, as: :has_many
  end
end
