class Avo::Resources::OrchestraPosition < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :idlo
    field :start_date, as: :date
    field :end_date, as: :date
    field :principal, as: :boolean
    field :orchestra_id, as: :text
    field :orchestra_role_id, as: :text
    field :person_id, as: :text
    field :orchestra, as: :belongs_to
    field :orchestra_role, as: :belongs_to
    field :person, as: :belongs_to
  end
end
