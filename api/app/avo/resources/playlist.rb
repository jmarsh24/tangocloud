class Avo::Resources::Playlist < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :title, as: :text
    field :description, as: :textarea
    field :public, as: :boolean
    field :songs_count, as: :number, only_on: :show
    field :likes_count, as: :number, only_on: :show
    field :listens_count, as: :number, only_on: :show
    field :shares_count, as: :number, only_on: :show
    field :followers_count, as: :number, only_on: :show
    field :user_id, as: :hidden, default: -> { Current.user.id }
    field :playlist_audio_transfers, as: :has_many
    field :image, as: :file, is_image: true, accept: "image/*", direct_upload: true, display_filename: false
    field :playlist_file, as: :file, accept: "m3u8"
  end
end
