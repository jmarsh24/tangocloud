class Avo::Resources::Tanda < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search = {
    query: -> { query.search(params[:q]).results }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :title, as: :text, required: true
    field :subtitle, as: :text
    field :description, as: :textarea
    field :public, as: :boolean
    field :system, as: :boolean, only_on: :show
  end
end
