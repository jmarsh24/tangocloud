class Avo::Resources::UserLibrary < Avo::BaseResource
  self.includes = [:user, :library_items]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, hide_on: [:index]
    field :user, as: :belongs_to
    field :library_items, as: :has_many
  end
end
