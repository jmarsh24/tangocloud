class Avo::Resources::Tanda < Avo::BaseResource
  self.title = :title
  self.includes = [:playlist_items]
  self.attachments = [:image, :playlist_file]
  self.search = {
    query: -> { query.search(params[:q]).results }
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
    field :playlist_file, as: :file, accept: "m3u8", required: true, hide_on: :index
    field :title, as: :text, required: true
    field :subtitle, as: :text
    field :description, as: :textarea
    field :public, as: :boolean
    field :system, as: :boolean, only_on: :show
    field :user, as: :belongs_to
    field :playlist_items, as: :has_many
  end
end
