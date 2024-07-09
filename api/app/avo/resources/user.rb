class Avo::Resources::User < Avo::BaseResource
  self.includes = []
  self.search = {
    query: -> { query.search(params[:q]).results }
  }

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
    field :user_preference, as: :has_one
    field :playbacks, as: :has_many
  end
end
