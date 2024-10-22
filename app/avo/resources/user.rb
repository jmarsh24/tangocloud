class Avo::Resources::User < Avo::BaseResource
  self.title = :email
  self.includes = [:playbacks, :playlists, :tandas]
  self.search = {
    query: -> { query.search(params[:q]).results }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :avatar, as: :file, is_image: true, display_filename: false, required: false
    field :email, as: :text
    field :verified, as: :boolean
    field :provider, as: :text
    field :uid, as: :text
    field :role, as: :select, options: User.roles.keys.map { |role| {value: role, label: role.titleize} }
    field :playbacks, as: :has_many
    field :playlists, as: :has_many
    field :tandas, as: :has_many
  end
end
