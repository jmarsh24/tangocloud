class Avo::Resources::Waveform < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :audio_transfer_id, as: :text
    field :version, as: :number
    field :channels, as: :number
    field :sample_rate, as: :number
    field :samples_per_pixel, as: :number
    field :bits, as: :number
    field :length, as: :number
    field :data, as: :number
    field :audio_transfer, as: :belongs_to
  end
end
