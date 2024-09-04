class Avo::Resources::Recording < Avo::BaseResource
  self.title = :title
  self.includes = [
    :orchestra,
    :composition,
    :record_label,
    :genre,
    :time_period,
    :el_recodo_song,
    :digital_remasters,
    :audio_variants,
    :recording_singers,
    :singers,
    :lyrics,
    :playlist_items,
    :tandas
  ]
  self.search = {
    query: -> { query.search(params[:q]).results }
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
    field :time_period, as: :belongs_to
    field :el_recodo_song, as: :belongs_to
    field :digital_remasters, as: :has_many
    field :audio_variants, as: :has_many, through: :digital_remasters
    field :recording_singers, as: :has_many
    field :singers, as: :has_many, through: :recording_singers
    field :lyrics, as: :has_many, through: :compositions
    field :playlist_items, as: :has_many
    field :tandas, as: :has_many, through: :playlist_items
    field :waveform, as: :has_one, through: :digital_remasters
    field :playbacks, as: :has_many
  end
end
