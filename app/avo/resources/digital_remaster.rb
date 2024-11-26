class Avo::Resources::DigitalRemaster < Avo::BaseResource
  self.includes = [:audio_file, :album, :remaster_agent, :audio_variants, :waveform, recording: [:composition], acr_cloud_recognition: [:external_identifiers]]
  self.search = {
    query: -> do
      DigitalRemaster.search(params[:q], includes: [:album, recording: [:genre, :orchestra, :composition]]).map do |result|
        {
          _id: result.id,
          _label: result.recording.title,
          _url: avo.resources_digital_remasters_path(result),
          _description: "#{result.recording.genre.name} - #{result.recording.orchestra.name} - #{result.recording.year}",
          _avatar: result.album.album_art.url
        }
      end
    end,
    item: -> do
      {
        title: "[#{record.id}] #{record.title}",
        subtitle: record.subtitle
      }
    end
  }
  self.title = -> {
    record.recording.title
  }

  def fields
    field :id, as: :id, only_on: :show
    field :duration, as: :number, only_on: [:show, :edit, :new], readonly: true
    field :bpm, as: :number, only_on: [:show, :edit, :new], readonly: true
    field :replay_gain, as: :number, only_on: [:show, :edit, :new], readonly: true
    field :audio_file, as: :belongs_to, readonly: true
    field :album, as: :belongs_to, readonly: true
    field :recording, as: :belongs_to, readonly: true
    field :remaster_agent, as: :belongs_to, readonly: true
    field :audio_variants, as: :has_many, readonly: true
    field :acr_cloud_recognition, as: :has_one, readonly: true, hide_on: :index
    field :external_identifiers, as: :has_one, readonly: true, hide_on: :index
    field :waveform, as: :has_one, readonly: true, hide_on: :index
    field :created_at, as: :date_time, sortable: true, only_on: [:index, :show]
  end
end
