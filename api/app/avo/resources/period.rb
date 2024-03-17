class Avo::Resources::Period < Avo::BaseResource
  self.includes = []
  self.search = {
    query: -> { query.search_periods(params[:q]) }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :photo, as: :file, is_image: true
    field :name, as: :text
    field :description, as: :textarea
    field :start_year, as: :number
    field :end_year, as: :number
    field :recordings_count, as: :number
    field :slug, as: :text
    field :record, as: :belongs_to
  end
end
