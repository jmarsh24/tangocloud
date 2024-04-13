class Avo::Resources::Orchestra < Avo::BaseResource
  self.includes = [:recordings, :singers, :compositions, :composers, :lyricists]
  self.search = {
    query: -> { query.search_orchestras(params[:q]) }
  }
  self.find_record_method = -> {
    if id.is_a?(Array)
      query.where(slug: id)
    else
      # We have to add .friendly to the query
      query.friendly.find id
    end
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :photo, as: :file, is_image: true, accept: "image/*"
    field :name, as: :text, format_using: -> do
      value.titleize
    end
    field :rank, as: :number
    field :sort_name, as: :text, only_on: :show
    field :birth_date, as: :date, only_on: :show
    field :death_date, as: :date, only_on: :show
    field :slug, as: :text, readonly: true, only_on: :show
    field :recordings, as: :has_many
    field :singers, as: :has_many, through: :recordings
    field :compositions, as: :has_many, through: :recordings
    field :composers, as: :has_many, through: :compositions
    field :lyricists, as: :has_many, through: :compositions
  end
end
