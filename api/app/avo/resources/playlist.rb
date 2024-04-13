class Avo::Resources::Playlist < Avo::BaseResource
  self.includes = [:playlist_items, :user]
  self.search = {
    query: -> { query.search_playlists(params[:q]).result(distinct: false) }
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
    field :image, as: :file, is_image: true, accept: "image/*", direct_upload: true, display_filename: false, required: false
    field :title, as: :text, required: false
    field :description, as: :textarea
    field :public, as: :boolean
    field :playlist_file, as: :file, accept: "m3u8", required: true
    field :system, as: :boolean, only_on: :show
    field :songs_count, as: :number, only_on: :show
    field :likes_count, as: :number, only_on: :show
    field :listens_count, as: :number, only_on: :show
    field :shares_count, as: :number, only_on: :show
    field :followers_count, as: :number, only_on: :show
    field :user_id, as: :hidden, default: -> { Current.user.id }
    field :playlist_items, as: :has_many
  end
end
