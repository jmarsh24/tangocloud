class Avo::Resources::AudioFile < Avo::BaseResource
  self.includes = [:digital_remaster]
  self.search = {
    query: -> do
      AudioFile.search(
        params[:q],
        fields: [:filename, :title, :orchestra, :status],
        includes: [digital_remaster: [:album]],
        match: :word_middle,
        operator: "or"
      ).map do |result|
        {
          _id: result.id,
          _label: result.filename,
          _url: avo.resources_audio_file_path(result),
          _avatar: result.digital_remaster&.album&.album_art&.url
        }
      end
    end
  }
  self.title = :filename

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :filename, as: :text
    field :status, as: :select, enum: ::AudioFile.statuses
    field :error_message, as: :text
    field :digital_remaster, as: :has_one
    field :file, as: :file
  end

  def filters
    filter Avo::Filters::StatusFilter
  end
end
