class Avo::Resources::User < Avo::BaseResource
  self.title = :email
  self.includes = [:playbacks, :playlists, :tandas]
  self.index_query = -> { query.where(role: [:tester, :admin]) }
  self.search = {
    query: -> do
      User.search(params[:q]).map do |result|
        {
          _id: result.id,
          _label: result.email,
          _url: avo.resources_users_path(result),
          _description: result.username,
          _avatar: result.avatar&.url
        }
      end
    end,
    item: -> do
      {
        title: "[#{record.id}] #{record.email}",
        subtitle: record.subtitle
      }
    end
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :avatar, as: :file, is_image: true, display_filename: false, required: false
    field :email, as: :text
    field :username, as: :text
    field :verified, as: :boolean
    field :provider, as: :text
    field :uid, as: :text
    field :role, as: :select, options: User.roles.keys.map { |role| [role.humanize.capitalize, role] }.to_h
    field :playbacks, as: :has_many
    field :playlists, as: :has_many
    field :tandas, as: :has_many
  end
end
