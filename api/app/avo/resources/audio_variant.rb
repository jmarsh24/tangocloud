class Avo::Resources::AudioVariant < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :audio_file, as: :file, readonly: true, display_filename: false
    field :duration, as: :number, readonly: true, only_on: :show
    field :format, as: :text, readonly: true, only_on: :show
    field :codec, as: :text, readonly: true, only_on: :show
    field :bit_rate, as: :number, readonly: true, only_on: :show
    field :sample_rate, as: :number, readonly: true, only_on: :show
    field :channels, as: :number, readonly: true, only_on: :show
    field :audio_transfer, as: :belongs_to, readonly: true
    field :metadata, as: :code, readonly: true, only_on: :show do
      if record.metadata.present?
        JSON.pretty_generate(record.metadata.as_json)
      end
    end
  end
end
