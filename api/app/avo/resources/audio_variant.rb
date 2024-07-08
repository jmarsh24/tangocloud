class Avo::Resources::AudioVariant < Avo::BaseResource
  self.includes = [:digital_remaster]
  self.search = {
    query: -> { query.search(params[:q]).results }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :audio_file, as: :file, readonly: true, display_filename: false
    field :format, as: :text, readonly: true, only_on: :show
    field :bit_rate, as: :number, readonly: true, only_on: :show
    field :digital_remaster, as: :belongs_to, readonly: true
  end
end
