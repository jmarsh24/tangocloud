class Avo::Resources::Playlist < Avo::BaseResource
  self.title = :title
  self.includes = [:playlist_items, :user, :playlist_type]
  self.attachments = [:playlist_file, :image]
  self.search = {
    query: -> do
      Playlist.search(params[:q], fields: [:title, :subtitle, :description], match: :word_start).map do |result|
        {
          _id: result.id,
          _label: result.title,
          _url: avo.resources_playlists_path(result),
          _description: result.subtitle,
          _avatar: result.image&.url
        }
      end
    end
  }
  self.index_query = -> { query.exclude_liked }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :import_as_tandas, as: :boolean
    field :playlist_file, as: :file, accept: ".m3u8", required: true, hide_on: :index
    field :image, as: :file, is_image: true, accept: "image/*", display_filename: false, required: false
    field :title, as: :text, required: false
    field :subtitle, as: :text, required: false
    field :description, as: :textarea
    field :public, as: :boolean
    field :user, as: :belongs_to
    field :playlist_items, as: :has_many
    field :playlist_type, as: :belongs_to
    field :created_at, as: :date, sortable: true
    field :updated_at, as: :date, only_on: :index, sortable: true
  end
end
