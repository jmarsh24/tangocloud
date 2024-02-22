class Avo::Resources::AudioTransfer < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :external_id, as: :text
    field :position, as: :number
    field :album_id, as: :text
    field :transfer_agent_id, as: :text
    field :recording_id, as: :text
    field :filename, as: :text
    field :audio_file, as: :file
    field :transfer_agent, as: :belongs_to
    field :recording, as: :belongs_to
    field :album, as: :belongs_to
    field :audio_variants, as: :has_many
    field :waveform, as: :has_one
  end
end
