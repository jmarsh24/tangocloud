class Avo::Resources::Waveform < Avo::BaseResource
  self.includes = [:audio_transfer, :album, :recording, :transfer_agent, :audio_variants]
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :image, as: :file, is_image: true, readonly: true, display_filename: false
    field :audio_transfer_id, as: :text
    field :version, as: :number, readonly: true
    field :channels, as: :number, readonly: true
    field :sample_rate, as: :number, readonly: true
    field :samples_per_pixel, as: :number, readonly: true
    field :bits, as: :number, readonly: true
    field :length, as: :number, readonly: true
    field :data, as: :number, readonly: true, hide_on: [:index, :edit, :new, :show]
    field :audio_transfer, as: :belongs_to, readonly: true
  end
end
