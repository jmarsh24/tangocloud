module Import
  module Music
    class SongImporter
      include TextNormalizable
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
          lyricist = Lyricist.find_or_create_by!(name: @metadata.lyricist)
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

          orchestra = Orchestra.find_or_create_by!(name: @metadata.album_artist)

          record_label = if @metadata.record_label.present?
            RecordLabel.find_or_create_by!(name: @metadata.record_label)
          end

          genre = if @metadata.genre.present?
            Genre.find_or_create_by!(name: @metadata.genre)
          end

          el_recodo_song = ElRecodoSong.find_by!(ert_number: @metadata.ert_number)

          singer = if @metadata.singer.present?
            Singer.find_or_create_by!(name: @metadata.singer)
          end

          parsed_date =
            begin
              Date.parse(@metadata.date)
            rescue Date::Error
              # If parsing fails, set a default date, e.g., January 1st of the given year
              year = @metadata.date.to_i
              Date.new(year, 1, 1) if year > 0
            end

          recording = Recording.create!(
            title: @metadata.title,
            bpm: @metadata.bpm,
            recorded_date: parsed_date,
            release_date: parsed_date,
            el_recodo_song:,
            singer:,
            orchestra:,
            composition:,
            record_label:,
            genre:
          )

          transfer_agent = TransferAgent.find_or_create_by(name: @metadata.encoded_by || "Unknown")

          audio_transfer = AudioTransfer.create!(
            external_id: @metadata.catalog_number,
            transfer_agent:,
            recording:
          )

          transfer_agent.audio_transfers << audio_transfer

          audio_converter = AudioProcessing::AudioConverter.new(file:)

          audio = audio_transfer.audios.create!(
            bit_rate: audio_converter.bitrate.to_i,
            sample_rate: audio_converter.sample_rate,
            channels: audio_converter.channels,
            codec: audio_converter.codec,
            length: audio_converter.movie.duration.to_i,
            format: audio_converter.format,
            metadata: @metadata
          )

          audio_converter.convert do |file|
            audio.file.attach(io: File.open(file), filename: File.basename(file))
          end

          audio_transfer
        end
      end
    end
  end
end
