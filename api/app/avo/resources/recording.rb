class Avo::Resources::Recording < Avo::BaseResource
  self.includes = [:orchestra,
    :composition,
    :record_label,
    :genre,
    :period,
    :el_recodo_song,
    :audio_transfers,
    :audio_variants,
    :recording_singers,
    :singers,
    :lyrics,
    :tanda_recordings,
    :tandas,
    :waveforms]
  self.search = {
    query: -> { query.search_recordings(params[:q]) }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :title, as: :text
    field :bpm, as: :number, only_on: :show
    field :release_date, as: :date, only_on: :show
    field :recorded_date, as: :date, only_on: :show
    field :slug, as: :text, only_on: :show
    field :recording_type, as: :select, enum: ::Recording.recording_types, only_on: :show
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
    field :lyrics, as: :has_many, through: :compositions
    field :tanda_recordings, as: :has_many
    field :tandas, as: :has_many, through: :tanda_recordings
    field :waveforms, as: :has_many, through: :audio_transfers
  end
end
