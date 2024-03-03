class Avo::Resources::ListenHistory < Avo::BaseResource
  self.includes = []

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :listens, as: :has_many
  end
end
