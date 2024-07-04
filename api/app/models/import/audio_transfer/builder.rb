module Import
  module AudioTransfer
    class Builder
      attr_reader :audio_transfer

      def initialize
        @audio_transfer = ::AudioTransfer.new
      end

      def extract_metadata(file:)
        AudioProcessing::MetadataExtractor.new(file:).metadata
      end

      def generate_waveform_image(file:)
        AudioProcessing::WaveformGenerator.new(file:).image
      end

      def generate_waveform_data(file:)
        AudioProcessing::WaveformGenerator.new(file:).json
      end

      def extract_album_art(file:)
        AudioProcessing::AlbumArtExtractor.new(file:).extract
      end

      def compress_audio(file:)
        AudioProcessing::AudioConverter.new(file:).convert
      end

      def build_audio_variant(metadata:)
        AudioVariant.new(
          duration: metadata.duration,
          format: metadata.format,
          codec: metadata.codec,
          filename: metadata.filename,
          bit_rate: metadata.bit_rate,
          sample_rate: metadata.sample_rate,
          channels: metadata.channels,
          length: metadata.length,
          metadata: metadata.to_h
        )
      end

      def build_waveform(waveform_data:)
        Waveform.new(data: waveform_data)
      end

      def build_and_attach_audio_transfer(audio_file:, metadata:, waveform_data:, waveform_image:, album_art:, compressed_audio:)
        album = find_or_initialize_album(metadata:)
        transfer_agent = find_or_initialize_transfer_agent(metadata:)
        recording = find_or_initialize_recording(metadata:)
        audio_variant = build_audio_variant(metadata:)
        waveform = build_waveform(waveform_data:)

        @audio_transfer = AudioTransfer.new(
          filename: audio_file.filename,
          album:,
          transfer_agent:,
          recording:,
          audio_variant:,
          waveform:
        )

        album.album_art.attach(io: File.open(album_art), filename: File.basename(album_art))
        audio_variant.audio_file.attach(io: File.open(compressed_audio), filename: File.basename(compressed_audio))
        waveform.image.attach(io: File.open(waveform_image), filename: File.basename(waveform_image))

        @audio_transfer
      end

      def find_or_initialize_album(metadata:)
        Album.find_or_initialize_by(title: metadata.album) do |album|
          album.description = metadata.album_description
          album.release_date = metadata.release_date
          album.album_type = metadata.album_type || "compilation"
        end
      end

      def find_or_initialize_transfer_agent(metadata:)
        TransferAgent.find_or_initialize_by(name: metadata.source)
      end

      def find_or_initialize_recording(metadata:)
        Recording.find_or_initialize_by(title: metadata.title) do |recording|
          recording.release_date = metadata.date
          recording.recording_type = metadata.recording_type || "studio"
          recording.orchestra = find_or_initialize_orchestra(metadata:)
          recording.genre = find_or_initialize_genre(metadata:)
          recording.composition = find_or_initialize_composition(metadata:)
          recording.singers = find_or_initialize_singers(metadata:)
        end
      end

      def find_or_initialize_orchestra(metadata:)
        Orchestra.find_or_initialize_by(name: metadata.album_artist) do |orchestra|
          orchestra.sort_name = metadata.orchestra_sort_name
          orchestra.birth_date = metadata.orchestra_birth_date
          orchestra.death_date = metadata.orchestra_death_date
        end
      end

      def find_or_initialize_singers(metadata:)
        metadata.artist.map do |singer_name|
          Singer.find_or_initialize_by(name: singer_name)
        end
      end

      def find_or_initialize_genre(metadata:)
        Genre.find_or_initialize_by(name: metadata.genre)
      end

      def find_or_initialize_composer(metadata:)
        Composer.find_or_initialize_by(name: metadata.composer) do |composer|
          composer.birth_date = metadata.composer_birth_date
          composer.death_date = metadata.composer_death_date
        end
      end

      def find_or_initialize_lyricist(metadata:)
        Lyricist.find_or_initialize_by(name: metadata.lyricist) do |lyricist|
          lyricist.birth_date = metadata.lyricist_birth_date
          lyricist.death_date = metadata.lyricist_death_date
        end
      end

      def find_or_initialize_composition(metadata:)
        composition = Composition.find_or_initialize_by(title: metadata.title) do |comp|
          comp.composer = find_or_initialize_composer(metadata:)
          comp.lyricist = find_or_initialize_lyricist(metadata:)
        end
        find_or_initialize_lyrics(metadata:, composition:)
        composition
      end

      def find_or_initialize_lyrics(metadata:, composition:)
        return if metadata.lyrics.blank?

        composition.lyrics.find_or_initialize_by(content: metadata.lyrics) do |lyric|
          lyric.locale = "es"
        end
      end
    end
  end
end
