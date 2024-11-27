class Avo::Resources::TimePeriod < Avo::BaseResource
  self.includes = [:recording]
  self.search = {
    query: -> { query.search(params[:q]) }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :image, as: :file, is_image: true
    field :name, as: :text
    field :description, as: :textarea
    field :start_year, as: :number
    field :end_year, as: :number
    field :slug, as: :text
    field :record, as: :belongs_to
  end
end
