class Avo::Resources::DigitalRemaster < Avo::BaseResource
  self.includes = [:audio_file, :album, :recording, :remaster_agent, :audio_variants]
  self.search = {
    query: -> { query.search(params[:q]).results }
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
    field :waveform, as: :has_one, readonly: true
  end
end
