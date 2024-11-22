class AcrCloudRecognitionJob < ApplicationJob
  queue_as :background

  limits_concurrency to: 20, key: "acr_cloud_recognition", duration: 1.minute

  def perform(digital_remaster)
    acr_cloud_recognition = digital_remaster.acr_cloud_recognition ||
      digital_remaster.build_acr_cloud_recognition(status: "pending")

    acr_cloud_recognition.update!(status: "processing")

    audio_file = digital_remaster.audio_file
    result = audio_file.file.open do |file|
      AcrCloud.new.recognize(file)
    end

    if result[:success]
      acr_cloud_recognition.update!(
        status: "completed",
        metadata: result[:metadata]
      )

      music_metadata = result[:metadata][:music].first

      recording = digital_remaster.recording

      if (youtube_vid = music_metadata.dig(:external_metadata, :youtube, :vid))
        ::ExternalIdentifier.find_or_create_by!(
          recording: recording,
          service_name: "YouTube",
          external_id: youtube_vid
        ) do |identifier|
          identifier.metadata = {
            track_title: music_metadata[:title],
            artist_name: music_metadata.dig(:artists, 0, :name),
            album_name: music_metadata.dig(:album, :name),
            confidence_score: music_metadata[:score]
          }
        end
      end

      if (spotify_id = music_metadata.dig(:external_metadata, :spotify, :track, :id))
        ::ExternalIdentifier.find_or_create_by!(
          recording: recording,
          service_name: "Spotify",
          external_id: spotify_id
        ) do |identifier|
          identifier.metadata = {
            track_title: music_metadata[:title],
            artist_name: music_metadata.dig(:artists, 0, :name),
            album_name: music_metadata.dig(:album, :name),
            confidence_score: music_metadata[:score]
          }
        end
      end
    else
      acr_cloud_recognition.update!(
        status: "failed",
        metadata: {error: result[:error]}
      )
    end
  end
end
