class Avo::Resources::Waveform < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :audio_transfer, as: :belongs_to
    field :version, as: :number
    field :channel, as: :number
    field :sample_rate, as: :number
    field :samples_per_pixel, as: :number
    field :bits, as: :number
    field :length, as: :number
    field :data, as: :array
  end
end
