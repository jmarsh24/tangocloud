class Avo::Resources::Listen < Avo::BaseResource
  self.includes = []

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :recording, as: :belongs_to
  end
end
