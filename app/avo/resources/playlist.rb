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

  self.ordering = {
    visible_on: :index,
    actions: {
      higher: -> { record.move_higher },
      lower: -> { record.move_lower },
      to_top: -> { record.move_to_top },
      to_bottom: -> { record.move_to_bottom }
    }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :playlist_file, as: :file, accept: "m3u8", required: true
    field :image, as: :file, is_image: true, accept: "image/*", direct_upload: true, display_filename: false, required: false
    field :title, as: :text, required: false
    field :subtitle, as: :text, required: false
    field :description, as: :textarea
    field :public, as: :boolean
    field :system, as: :boolean, only_on: :show
    field :user, as: :belongs_to
    field :playlist_items, as: :has_many
  end
end
