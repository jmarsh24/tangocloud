class Avo::Resources::Playlist < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :description, as: :textarea
    field :public, as: :boolean
    field :songs_count, as: :number
    field :likes_count, as: :number
    field :listens_count, as: :number
    field :shares_count, as: :number
    field :followers_count, as: :number
    field :user_id, as: :text
    field :user, as: :belongs_to
    field :playlist_audio_transfers, as: :has_many
  end
end
