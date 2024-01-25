# frozen_string_literal: true

module Import
  module Music
    class SongImporter
      attr_reader :file

      SUPPORTED_MIME_TYPES = ["audio/x-aiff", "audio/flac", "audio/mp4", "audio/mpeg"].freeze

      def initialize(file:)
        @file = file.to_s
        @metadata = AudioProcessing::MetadataExtractor.new(file:).extract_metadata
      end

      def import
        mime_type = Marcel::MimeType.for(Pathname.new(file))
        return unless SUPPORTED_MIME_TYPES.include?(mime_type)

        ActiveRecord::Base.transaction do
          audio = Audio.create!(
            channels: @metadata.channels,
            sample_rate: @metadata.samplerate,
            bit_rate: @metadata.bitrate,
            bit_depth: @metadata.bitdepth,
            duration: @metadata.duration,
            format: @metadata.filetype,
            duration: @metadata.duration
          )
          audio_transfer = AudioTransfer.create(file_path: file)
          album = find_or_create_album
          recording = create_recording(album)
          create_audio(recording)
          link_artists(recording)
        end
      end

      private

      def find_or_create_album
        album_title = @metadata.album
        album = Album.find_or_create_by(title: album_title) do |album|
          cover_art = AudioProcessing::CoverArtExtractor.new(file:).extract_cover_art
          album.cover_image.attach(io: File.open(cover_art), filename: "#{album_title}.jpg") if cover_art.present?
        end
      end

      def create_recording(album)
        album.recordings.create(
          title: @metadata.title,
          year: @metadata.year
        )
      end

      def create_audio(recording)
        recording.audios.create(
          file_path:,
          format: File.extname(file_path).downcase
        )
      end

      def link_artists(recording)
        singer = Singer.find_or_create_by(name: @metadata.artist)
        recording.singers << singer

        orchestra = Orchestra.find_or_create_by(name: @metadata.albumartist)
        recording.orchestras << orchestra

        lyricist = Lyricist.find_or_create_by(name: @metadata.lyricist)
        recording.lyricists << lyricist

        composer = Composer.find_or_create_by(name: @metadata.composer)
        recording.composers << composer
      end
    end
  end
end
