class Avo::Resources::Tanda < Avo::BaseResource
  self.title = :title
  self.includes = [:user, :tanda_recordings, :recordings]
  self.attachments = [:image, :playlist_file]
  self.search = {
    query: -> do
      Tanda.search(params[:q], fields: [:title, :subtitle, :description], match: :word_start).map do |result|
        {
          _id: result.id,
          _label: result.title,
          _url: "/admin/resources/tandas/#{result.id}",
          _description: result.subtitle,
          _avatar: result.image&.url
        }
      end
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
    field :id, as: :id, hide_on: :index
    field :image, as: :file, is_image: true, accept: "image/*", display_filename: false, required: false
    field :title, as: :text
    field :subtitle, as: :text, hide_on: :index
    field :description, as: :textarea
    field :user, as: :belongs_to
    field :public, as: :boolean
    field :system, as: :boolean
    field :playlist_file, as: :file, accept: "m3u8", required: true, hide_on: :index
    field :tanda_recordings, as: :has_many
    field :likes, as: :has_many
    field :shares, as: :has_many
  end
end
