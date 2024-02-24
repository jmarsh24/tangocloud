class Avo::Resources::Lyric < Avo::BaseResource
  self.includes = [:composition]
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :locale, as: :text
    field :content, as: :textarea, format_using: -> do
      simple_format(value)
    end
    field :composition, as: :belongs_to
  end
end
