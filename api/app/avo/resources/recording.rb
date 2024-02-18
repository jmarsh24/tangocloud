class Avo::Resources::Recording < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :bpm, as: :number
    field :release_date, as: :date
    field :recorded_date, as: :date
    field :slug, as: :text
    field :recording_type, as: :select, enum: ::Recording.recording_types
    field :el_recodo_song_id, as: :text
    field :orchestra_id, as: :text
    field :singer_id, as: :text
    field :composition_id, as: :text
    field :record_label_id, as: :text
    field :genre_id, as: :text
    field :period_id, as: :text
    field :orchestra, as: :belongs_to
    field :composition, as: :belongs_to
    field :record_label, as: :belongs_to
    field :genre, as: :belongs_to
    field :period, as: :belongs_to
    field :el_recodo_song, as: :belongs_to
    field :audio_transfers, as: :has_many
    field :audio_variants, as: :has_many, through: :audio_transfers
    field :recording_singers, as: :has_many
    field :singers, as: :has_many, through: :recording_singers
    field :lyrics, as: :belongs_to
    field :tanda_recordings, as: :has_many
    field :tandas, as: :has_many, through: :tanda_recordings
    field :waveforms, as: :has_many, through: :audio_transfers
  end
end
