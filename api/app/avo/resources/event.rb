class Avo::Resources::Event < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user_id, as: :text
    field :action, as: :text
    field :user_agent, as: :text
    field :ip_address, as: :text
    field :user, as: :belongs_to
  end
end
