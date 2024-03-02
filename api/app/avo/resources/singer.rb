class Avo::Resources::Singer < Avo::BaseResource
  self.includes = [:recording_singers, :recordings]
  self.search = {
    query: -> { query.search_singers(params[:q]).results }
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
    field :name, as: :text
    field :slug, as: :text, only_on: :show
    field :rank, as: :number, only_on: :show
    field :sort_name, as: :text, only_on: :show
    field :bio, as: :textarea, only_on: :show, format_using: -> { simple_format value }
    field :birth_date, as: :date, only_on: :show
    field :death_date, as: :date, only_on: :show
    field :recording_singers, as: :has_many
    field :recordings, as: :has_many, through: :recording_singers
  end
end
