# frozen_string_literal: true

module Import
  module Music
    class SongImporter
      attr_reader :file_path

      SUPPORTED_FORMATS = [".aif", ".flac", ".mp3", ".aac", ".m4a"].freeze

      def initialize(file_path:)
        @file_path = file_path
        @tag = WahWah.open(file_path)
      end

      def import
        return unless SUPPORTED_FORMATS.include?(File.extname(file_path).downcase)

        ActiveRecord::Base.transaction do
          album = find_or_create_album
          recording = create_recording(album)
          create_audio(recording)
          link_artists(recording)
        end
      end

      private

      def find_or_create_album
        Album.find_or_create_by(title: @tag.album) do |album|
        end
      end

      def create_recording(album)
        album.recordings.create(
          title: @tag.title,
          year: @tag.year
        )
      end

      def create_audio(recording)
        recording.audios.create(
          file_path:,
          format: File.extname(file_path).downcase
        )
      end

      def link_artists(recording)
        # Create or find the singer
        singer = Singer.find_or_create_by(name: @tag.artist)
        recording.singers << singer

        # Create or find the orchestra
        orchestra = Orchestra.find_or_create_by(name: @tag.albumartist)
        recording.orchestras << orchestra

        # Create or find the lyricist
        lyricist = Lyricist.find_or_create_by(name: @tag.lyricist)
        recording.lyricists << lyricist

        # Create or find the composer
        composer = Composer.find_or_create_by(name: @tag.composer)
        recording.composers << composer
      end
    end
  end
end
