module Import
  module Music
    class SongImporter
      class DuplicateFileError < StandardError; end
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
          Rails.logger.info("Importing song from #{file.inspect}")
          lyricist = Lyricist.find_or_create_by!(name: @metadata.lyricist) if @metadata.lyricist.present?
          composer = Composer.find_or_create_by!(name: @metadata.composer) if @metadata.composer.present?

          composition = Composition.find_or_create_by!(
            title: @metadata.title,
            lyricist:,
            composer:
          )

          if @metadata.lyrics.present?
            composition.lyrics.find_or_create_by!(
              content: @metadata.lyrics,
              locale: "es",
              composition:
            )
          end

          orchestra = Orchestra.find_or_create_by!(name: @metadata.album_artist)

          record_label = if @metadata.record_label.present?
            RecordLabel.find_or_create_by!(name: @metadata.record_label)
          end

          genre = if @metadata.genre.present?
            Genre.find_or_create_by!(name: @metadata.genre)
          end

          el_recodo_song = ElRecodoSong.find_by!(ert_number: @metadata.ert_number)
          if @metadata.singer.present? && @metadata.singer.downcase != "instrumental"
            singer = Singer.find_or_create_by!(name: @metadata.artist)
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
            orchestra:,
            composition:,
            record_label:,
            genre:
          )
          recording.singers << singer if singer.present?

          transfer_agent = TransferAgent.find_or_create_by(name: @metadata.encoded_by || "Unknown")

          album = Album.find_or_create_by!(
            title: @metadata.album,
            release_date: parsed_date
          )

          if !album.album_art.attached?
            AudioProcessing::AlbumArtExtractor.new(file:).extract do |file|
              album.album_art.attach(io: File.open(file), filename: File.basename(file))
            end
          end

          raise DuplicateFileError if album.audio_transfers.find_by(filename: File.basename(@file))

          audio_transfer = album.audio_transfers.create!(
            external_id: @metadata.catalog_number,
            transfer_agent:,
            recording:,
            position: @metadata.track || album.audio_transfers.count + 1,
            filename: File.basename(@file)
          )

          audio_transfer.source_audio.attach(io: File.open(@file), filename: File.basename(@file))

          waveform = AudioProcessing::WaveformGenerator.new(File.open(@file)).json

          audio_transfer.create_waveform!(
            version: waveform.version,
            channels: waveform.channels,
            sample_rate: waveform.sample_rate,
            samples_per_pixel: waveform.samples_per_pixel,
            bits: waveform.bits,
            length: waveform.length,
            data: waveform.data
          )

          transfer_agent.audio_transfers << audio_transfer

          audio_converter = AudioProcessing::AudioConverter.new(file:)

          audio_converter.convert do |file|
            audio_variant = audio_transfer.audio_variants.create!(
              bit_rate: audio_converter.bitrate.to_i,
              sample_rate: audio_converter.sample_rate,
              channels: audio_converter.channels,
              codec: audio_converter.codec,
              duration: audio_converter.movie.duration.to_i,
              format: audio_converter.format,
              filename: File.basename(file),
              metadata: @metadata
            )

            audio_variant.audio.attach(io: File.open(file), filename: File.basename(file))
          end
          audio_transfer
        end
      end
    end
  end
end
