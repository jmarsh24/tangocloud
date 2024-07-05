class Avo::Resources::AudioFile < Avo::BaseResource
  self.includes = []
  self.search = {
    query: -> do
      query = params[:q]
      AudioFile.
        ransack(id_eq: query, status_eq: query, filename_cont: query, m: "or")
        .result(distinct: false)
    end
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
