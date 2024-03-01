module Import
  module Music
    class AudioTransferImporter
      class DuplicateFileError < StandardError; end

      class UnsupportedMimeTypeError < StandardError; end

      SUPPORTED_MIME_TYPES = ["audio/x-aiff", "audio/x-flac", "audio/flac", "audio/mp4", "audio/mpeg", "audio/x-m4a", "audio/mp3"].freeze

      def import_from_file(file)
        import(file:)
      end

      def import_from_audio_transfer(audio_transfer)
        original_filename = audio_transfer.audio_file.filename.to_s

        Tempfile.create([File.basename(original_filename, File.extname(original_filename)), File.extname(original_filename)]) do |file|
          file.binmode

          audio_transfer.audio_file.open do |blob|
            file.write(blob.read)
            file.rewind
          end
          import(file:, audio_transfer:)
        end
      end

      def import(file:, audio_transfer: nil)
        filename = if audio_transfer.present?
          audio_transfer.filename
        else
          File.basename(file)
        end

        unless audio_transfer.present?
          raise DuplicateFileError if AudioTransfer.find_by(filename:)
        end

        metadata = AudioProcessing::MetadataExtractor.new(file).extract_metadata

        mime_type = Marcel::MimeType.for(Pathname.new(file))
        raise UnsupportedMimeTypeError unless SUPPORTED_MIME_TYPES.include?(mime_type)

        ActiveRecord::Base.transaction do
          Rails.logger.info("Importing song from #{file.inspect}")
          lyricist = Lyricist.find_or_create_by!(name: metadata.lyricist) if metadata.lyricist.present?
          composer = Composer.find_or_create_by!(name: metadata.composer) if metadata.composer.present?

          composition = Composition.find_or_create_by!(title: metadata.title) do |comp|
            comp.lyricist = lyricist if lyricist.present?
            comp.composer = composer if composer.present?
          end

          if metadata.lyrics.present?
            composition.lyrics.find_or_create_by!(content: metadata.lyrics, locale: "es", composition:)
          end

          orchestra = Orchestra.find_or_create_by!(name: metadata.album_artist)

          record_label = if metadata.record_label.present?
            RecordLabel.find_or_create_by!(name: metadata.record_label)
          end

          genre = if metadata.genre.present?
            Genre.find_or_create_by!(name: metadata.genre.downcase)
          end

          el_recodo_song = ElRecodoSong.find_by!(ert_number: metadata.ert_number)
          if metadata.singer.present? && metadata.singer.downcase != "instrumental"
            singer = Singer.find_or_create_by!(name: metadata.artist)
          end

          parsed_date =
            begin
              Date.parse(metadata.date)
            rescue Date::Error
              # If parsing fails, set a default date, e.g., January 1st of the given year
              year = metadata.date.to_i
              Date.new(year, 1, 1) if year > 0
            end

          recording = Recording.find_or_create_by!(
            title: metadata.title,
            bpm: metadata.bpm,
            recorded_date: parsed_date,
            release_date: parsed_date,
            el_recodo_song:,
            orchestra:,
            composition:,
            record_label:,
            genre:
          )
          recording.singers << singer if singer.present?

          transfer_agent = TransferAgent.find_or_create_by(name: metadata.encoded_by || "Unknown")

          album = Album.find_or_create_by!(
            title: metadata.album,
            release_date: parsed_date
          )

          unless album.album_art.attached?
            AudioProcessing::AlbumArtExtractor.new(file).extract do |file|
              album.album_art.attach(io: File.open(file), filename: File.basename(file))
            end
          end

          audio_transfer ||= album.audio_transfers.new(filename:)

          audio_transfer.album = album unless audio_transfer.album.present?

          audio_transfer.assign_attributes(
            external_id: metadata.catalog_number,
            transfer_agent:,
            recording:,
            position: metadata.track || album.audio_transfers.count + 1
          )

          audio_transfer.save!

          unless audio_transfer.audio_file.attached?
            audio_transfer.audio_file.attach(io: File.open(file), filename:)
          end

          unless audio_transfer.waveform
            waveform_json = AudioProcessing::WaveformGenerator.new(File.open(file)).json

            waveform = audio_transfer.create_waveform!(
              version: waveform_json.version,
              channels: waveform_json.channels,
              sample_rate: waveform_json.sample_rate,
              samples_per_pixel: waveform_json.samples_per_pixel,
              bits: waveform_json.bits,
              length: waveform_json.length,
              data: waveform_json.data
            )
            AudioProcessing::WaveformGenerator.new(File.open(file)).image do |image|
              waveform.image.attach(io: File.open(image), filename: File.basename(file, ".*") + ".png")
            end
          end

          transfer_agent.audio_transfers << audio_transfer

          audio_converter = AudioProcessing::AudioConverter.new(file)

          audio_converter.convert do |file|
            audio_variant = audio_transfer.audio_variants.find_or_create_by!(
              bit_rate: audio_converter.bitrate.to_i,
              sample_rate: audio_converter.sample_rate,
              channels: audio_converter.channels,
              codec: audio_converter.codec,
              duration: audio_converter.movie.duration.to_i,
              format: audio_converter.format,
              filename: audio_converter.filename,
              metadata:
            )

            audio_variant.audio_file.attach(io: File.open(file), filename: File.basename(file))
          end
          audio_transfer
        end
      end
    end
  end
end
