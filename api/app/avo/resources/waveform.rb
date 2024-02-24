class Avo::Resources::Waveform < Avo::BaseResource
  self.includes = [:audio_transfer]
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :image, as: :file, is_image: true, readonly: true, display_filename: false
    field :version, as: :number, readonly: true, only_on: :show
    field :channels, as: :number, readonly: true, only_on: :show
    field :sample_rate, as: :number, readonly: true, only_on: :show
    field :samples_per_pixel, as: :number, readonly: true, only_on: :show
    field :bits, as: :number, readonly: true, only_on: :show
    field :length, as: :number, readonly: true, only_on: :show
    field :data, as: :number, readonly: true, hide_on: [:index, :edit, :new, :show]
    field :audio_transfer, as: :belongs_to, readonly: true
  end
end
