class Avo::Resources::Playlist < Avo::BaseResource
  self.title = :title
  self.includes = [:playlist_items, :user]
  self.attachments = [:playlist_file, :image]
  self.search = {
    query: -> { query.search(params[:q]).results }
  }
  self.find_record_method = -> {
    if id.is_a?(Array)
      query.where(slug: id)
    else
      query.friendly.find id
    end
  }
  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :playlist_type, as: :select, options: Playlist.playlist_types.keys.map { [_1.titleize, _1] }
    field :playlist_file, as: :file, accept: "m3u8", required: true, hide_on: :index
    field :image, as: :file, is_image: true, accept: "image/*", display_filename: false, required: false
    field :title, as: :text, required: false
    field :slug, as: :text, hide_on: :index
    field :subtitle, as: :text, required: false
    field :description, as: :textarea
    field :public, as: :boolean
    field :user, as: :belongs_to
    field :playlist_items, as: :has_many
  end
end
