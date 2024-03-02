class Avo::Resources::Like < Avo::BaseResource
  self.includes = []

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :activity, as: :belongs_to
    field :created_at, as: :datetime
    field :updated_at, as: :datetime
  end
end
