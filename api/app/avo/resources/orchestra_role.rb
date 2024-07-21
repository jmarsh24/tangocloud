class Avo::Resources::OrchestraRole < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :idlo
    field :name, as: :text
    field :orchestra_id, as: :text
    field :orchestra_roles, as: :has_many
    field :orchestra, as: :belongs_to
  end
end
