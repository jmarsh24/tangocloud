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
            bit_rate: @metadata.bit_rate,
            sample_rate: @metadata.samplerate,
            channels: @metadata.channels,
            bit_depth: @metadata.bitdepth,
            bit_rate_mode: @metadata.bit_rate_mode,
            codec: @metadata.codec,
            length: @metadata.duration,
            encoder: @metadata.encoder,
            metadata: @metadata.to_h
          )

          audio.file.attach(io: File.open(file), filename: File.basename(file))
          transfer_agent = TransferAgent.find_or_create_by(name: @metadata.encoded_by) # TODO: This is not correct
          audio_transfer = transfer_agent.audio_transfer.create!(
            audio:,
            transfer_agent:,
            file_path:,
            external_id: nil, # possible to add this
            recording_date: nil,
            method: nil
          )

          album = find_or_create_album
          album.audio_transfer.create!(audio_transfer:, position: @metadata&.track)
          lyricist = Lyricist.find_or_create_by(name: @metadata.lyricist)
          composer = Composer.find_or_create_by(name: @metadata.composer)
          lyric = Lyric.find_or_create_by(
            content: @metadata.lyrics,
            locale: "es"
          )
          composition = Composition.find_or_create_by!(
            title: @metadata.title,
            lyricist:,
            composer:
          )
          composition.lyrics << lyric
          composition.save!
          orchestra = Orchestra.find_or_create_by(name: @metadata.artist)
          audio_transfer.recordings.create!(title: @metadata.title,
            bpm: @metadata.bpm,
            year: @metadata.date,
            release_date: @metadata.date,
            el_recodo_song: ElRecodoSong.find_by(title: @metadata.music_id), # TODO: This is not correct
            singer: Singer.find_or_create_by(name: @metadata.album_artist),
            orchestra:,
            composition:,
            label: Label.find_or_create_by(name: @metadata.publisher),
            genre: Genre.find_or_create_by(name: @metadata.genre))
        end
      end

      private

      def find_or_create_album
        album_title = @metadata.album
        Album.find_or_create_by(title: album_title) do |album|
          cover_art = AudioProcessing::CoverArtExtractor.new(file:).extract_cover_art
          if cover_art.present? && album.cover_image.blank?
            album.cover_image.attach(io: File.open(cover_art), filename: "#{album_title}.jpg")
          end
        end
      end
    end
  end
end
