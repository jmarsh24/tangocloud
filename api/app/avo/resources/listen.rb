class Avo::Resources::Listen < Avo::BaseResource
  self.includes = [:user, :recording]

  def fields
    field :id, as: :id, readonly: true, only_on: :show
  end
end
