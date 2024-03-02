class Avo::Resources::UserActivityLike < Avo::BaseResource
  self.includes = []
  self.model_class = ::UserActivity::Like
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :activity, as: :belongs_to
    field :created_at, as: :datetime
    field :updated_at, as: :datetime
  end
end
