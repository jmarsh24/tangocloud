class Avo::Resources::UserActivityListen < Avo::BaseResource
  self.includes = []
  self.model_class = ::UserActivity::Listen
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :recording, as: :belongs_to
  end
end
