class Avo::Resources::AudioVariant < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :duration, as: :number
    field :format, as: :text
    field :codec, as: :text
    field :bit_rate, as: :number
    field :sample_rate, as: :number
    field :channels, as: :number
    field :metadata, as: :text
    field :audio_transfer_id, as: :text
    field :filename, as: :text
    field :audio_file, as: :file
    field :audio_transfer, as: :belongs_to
  end
end
