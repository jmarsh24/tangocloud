class Avo::Resources::Event < Avo::BaseResource
  self.includes = [:user]
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :user, as: :belongs_to
    field :action, as: :text
    field :user_agent, as: :text
    field :ip_address, as: :text, only_on: :show
  end
end
