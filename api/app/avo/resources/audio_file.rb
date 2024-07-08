class Avo::Resources::AudioFile < Avo::BaseResource
  self.includes = [:digital_remaster]
  self.search = {
    query: -> { AudioFile.search(params[:q]).results }
  }

  def fields
    field :id, as: :id
    field :filename, as: :text
    field :status, as: :select, enum: ::AudioFile.statuses
    field :error_message, as: :text
    field :audio_transfer, as: :belongs_to
    field :file, as: :file
  end

  def filters
    filter StatusFilter
  end
end
