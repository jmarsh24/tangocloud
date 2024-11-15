class Avo::Resources::DigitalRemaster < Avo::BaseResource
  self.includes = [:audio_file, :album, :remaster_agent, :audio_variants, :waveform, recording: [:composition]]
  self.search = {
    query: -> { query.search(params[:q]).results }
  }
  self.title = -> {
    record.recording.composition.title
  }

  def fields
    field :id, as: :id, only_on: :show
    field :external_id, as: :text, only_on: [:show, :edit, :new], readonly: true
    field :duration, as: :number, only_on: [:show, :edit, :new], readonly: true
    field :bpm, as: :number, only_on: [:show, :edit, :new], readonly: true
    field :replay_gain, as: :number, only_on: [:show, :edit, :new], readonly: true
    field :audio_file, as: :belongs_to, readonly: true
    field :album, as: :belongs_to, readonly: true
    field :recording, as: :belongs_to, readonly: true
    field :remaster_agent, as: :belongs_to, readonly: true
    field :audio_variants, as: :has_many, readonly: true
    field :waveform, as: :has_one, readonly: true, hide_on: :index
    field :created_at, as: :date_time, sortable: true, only_on: [:index, :show]
  end
end
