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
          transfer_agent = TransferAgent.find_or_create_by(name: @metadata.encoded_by || "Unknown")

          audio = Audio.create(
            bit_rate: @metadata.bit_rate,
            sample_rate: @metadata.sample_rate,
            channels: @metadata.channels,
            bit_depth: @metadata.bit_depth,
            bit_rate_mode: @metadata.bit_rate_mode,
            codec: @metadata.codec_name,
            length: @metadata.duration,
            encoder: @metadata.encoder,
            metadata: @metadata.to_h
          )

          AudioProcessing::AudioConverter.new(file:).convert do |file|
            audio.file.attach(io: File.open(file), filename: File.basename(file))
          end

          audio_transfer = AudioTransfer.create!(
            audio:,
            transfer_agent:,
            external_id: nil, # possible to add this
            recording_date: nil,
            method: "audio transfer"
          )

          transfer_agent.audio_transfers << audio_transfer

          lyricist = Lyricist.find_or_create_by!(name: @metadata.artist)
          composer = Composer.find_or_create_by!(name: @metadata.composer)

          composition = Composition.find_or_create_by!(
            title: @metadata.title,
            lyricist:,
            composer:
          )

          composition.lyrics.find_or_create_by!(
            content: @metadata.lyrics,
            locale: "es",
            composition:
          )

          orchestra = Orchestra.find_or_create_by!(name: @metadata.artist)

          if @metadata.record_label.present?
            label = Label.find_or_create_by!(name: @metadata.label)
          end

          if @metadata.album_artist.present?
            genre = Genre.find_or_create_by!(name: @metadata.genre)
          end
          binding.irb
          audio_transfer.recording.create!(
            title: @metadata.title,
            bpm: @metadata.bpm,
            year: @metadata.date,
            release_date: @metadata.date,
            el_recodo_song: ElRecodoSong.find_by!(normalized_title: I18n.transliterate(@metadata.title).downcase, normalized_orchestra: I18n.transliterate(@metadata.album_artist).downcase), # TODO: This is not correct
            singer: Singer.find_or_create_by!(name: @metadata.album_artist),
            orchestra:,
            composition:,
            label:,
            genre:
          )
        end
      end
    end
  end
end
