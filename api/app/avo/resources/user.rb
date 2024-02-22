class Avo::Resources::User < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :email, as: :text
    field :verified, as: :boolean
    field :provider, as: :text
    field :uid, as: :text
    field :username, as: :text
    field :first_name, as: :text
    field :last_name, as: :text
    field :admin, as: :boolean
    field :avatar, as: :file
    field :sessions, as: :has_many
    field :events, as: :has_many
  end
end
