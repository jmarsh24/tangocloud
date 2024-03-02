class Avo::Resources::UserActivityHistory < Avo::BaseResource
  self.includes = []
  self.model_class = ::UserActivity::History
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :listens, as: :has_many
  end
end
