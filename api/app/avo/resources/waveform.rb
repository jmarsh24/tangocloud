class Avo::Resources::Waveform < Avo::BaseResource
  self.includes = [:digital_remaster]

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :image, as: :file, is_image: true, readonly: true, display_filename: false
    field :version, as: :number, readonly: true, only_on: :show
    field :channels, as: :number, readonly: true, only_on: :show
    field :sample_rate, as: :number, readonly: true, only_on: :show
    field :samples_per_pixel, as: :number, readonly: true, only_on: :show
    field :bits, as: :number, readonly: true, only_on: :show
    field :length, as: :number, readonly: true, only_on: :show
    field :data, as: :code, readonly: true, only_on: :show
    field :digital_remaster, as: :belongs_to, readonly: true
  end
end
