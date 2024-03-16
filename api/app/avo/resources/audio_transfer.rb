class Avo::Resources::AudioTransfer < Avo::BaseResource
  self.includes = [:waveform, :audio_variants, :album, :recording, :transfer_agent]
  self.search = {
    query: -> { query.search_audio_transfers(params[:q]) }
  }

  def fields
    field :id, as: :id, only_on: :show
    field :audio_file, as: :file, readonly: true, display_filename: false
    field :album, as: :belongs_to, readonly: true
    field :recording, as: :belongs_to, readonly: true
    field :transfer_agent, as: :belongs_to, readonly: true
    field :audio_variants, as: :has_many, readonly: true
    field :waveform, as: :has_one, readonly: true
    field :external_id, as: :text, only_on: [:show, :edit, :new], readonly: true
    field :position, as: :number, only_on: [:show, :edit, :new], readonly: true
    field :album_id, as: :text, only_on: [:show, :edit, :new], readonly: true
    field :transfer_agent_id, as: :text, only_on: [:show, :edit, :new], readonly: true
  end
end
