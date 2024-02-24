class Avo::Resources::Lyricist < Avo::BaseResource
  self.includes = [:lyrics, :compositions]
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
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
    field :compositions_count, as: :number, readonly: true
    field :slug, as: :text, readonly: true, only_on: :show
    field :sort_name, as: :text, only_on: :show
    field :birth_date, as: :date, only_on: :show
    field :death_date, as: :date, only_on: :show
    field :bio, as: :textarea, only_on: :show
    field :lyrics, as: :has_many
    field :compositions, as: :has_many
  end
end
