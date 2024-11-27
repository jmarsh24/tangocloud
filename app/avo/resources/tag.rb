class Avo::Resources::Tag < Avo::BaseResource
  self.title = :name
  self.includes = [:taggings]
  self.search = {
    query: -> { query.search(params[:q]) }
  }

  def fields
    field :id, as: :id, hide_on: [:index]
    field :name, as: :text
    field :taggings, as: :has_many

    field :created_at, as: :date_time
    field :updated_at, as: :date_time
  end
end
