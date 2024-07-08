class Avo::Resources::Genre < Avo::BaseResource
  self.includes = [:recordings]
  self.search = {
    query: -> { query.search(params[:q]).results }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :name, as: :text
    field :description, as: :textarea
    field :recordings, as: :has_many
  end
end
