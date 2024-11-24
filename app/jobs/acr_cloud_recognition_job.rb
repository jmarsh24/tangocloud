class AcrCloudRecognitionJob < ApplicationJob
  queue_as :background

  limits_concurrency to: 20, key: "acr_cloud_recognition", duration: 1.minute

  def perform(digital_remaster)
    acr_cloud_recognition = digital_remaster.acr_cloud_recognition ||
      digital_remaster.create_acr_cloud_recognition!(status: "pending")

    acr_cloud_recognition.update_column(:status, "processing")

    audio_file = digital_remaster.audio_file
    result = audio_file.file.open do |file|
      AcrCloud.new.recognize(file)
    end

    if result[:success] && result[:metadata][:music].present?
      acr_cloud_recognition.update!(
        status: "completed",
        metadata: result[:metadata],
        error_code: 0,
        error_message: "No error message"
      )

      music_metadata = result[:metadata][:music].first
      recording = digital_remaster.recording

      if (youtube_vid = music_metadata.dig(:external_metadata, :youtube, :vid))
        external_identifier = ::ExternalIdentifier.find_or_initialize_by(
          recording: recording,
          service_name: "youtube",
          external_id: youtube_vid
        )
        external_identifier.acr_cloud_recognition = acr_cloud_recognition
        external_identifier.metadata = {
          track_title: music_metadata[:title],
          artist_name: music_metadata.dig(:artists, 0, :name),
          album_name: music_metadata.dig(:album, :name),
          confidence_score: music_metadata[:score]
        }
        external_identifier.save!
      end

      if (spotify_id = music_metadata.dig(:external_metadata, :spotify, :track, :id))
        external_identifier = ::ExternalIdentifier.find_or_initialize_by(
          recording: recording,
          service_name: "spotify",
          external_id: spotify_id
        )
        external_identifier.acr_cloud_recognition = acr_cloud_recognition
        external_identifier.metadata = {
          track_title: music_metadata[:title],
          artist_name: music_metadata.dig(:artists, 0, :name),
          album_name: music_metadata.dig(:album, :name),
          confidence_score: music_metadata[:score]
        }
        external_identifier.save!
      end
    else
      error_code = result[:error_code]
      error_message = result[:error] || "Unknown recognition error"

      acr_cloud_recognition.update!(
        status: "failed",
        metadata: {error: error_message},
        error_code: error_code,
        error_message: error_message
      )
    end
  end
end
