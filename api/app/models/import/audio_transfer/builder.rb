module Import
  module AudioTransfer
    class Builder
      def initialize
        @audio_transfer = ::AudioTransfer.new
      end

      def extract_metadata(file:)
        AudioProcessing::MetadataExtractor.new(file:).extract
      end

      def generate_waveform_image(file:)
        AudioProcessing::WaveformGenerator.new(file:).generate_image
      end

      def generate_waveform(file:)
        AudioProcessing::WaveformGenerator.new(file:).generate
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
          codec: metadata.codec_name,
          bit_rate: metadata.bit_rate,
          sample_rate: metadata.sample_rate,
          channels: metadata.channels,
          metadata: metadata.to_h
        )
      end

      def build_waveform(waveform:)
        Waveform.new(
          version: waveform.version,
          channels: waveform.channels,
          sample_rate: waveform.sample_rate,
          samples_per_pixel: waveform.samples_per_pixel,
          bits: waveform.bits,
          length: waveform.length,
          data: waveform.data
        )
      end

      def build_and_attach_audio_transfer(audio_file:, metadata:, waveform:, waveform_image:, album_art:, compressed_audio:)
        album = find_or_initialize_album(metadata:)
        transfer_agent = find_or_initialize_transfer_agent(metadata:)
        recording = find_or_initialize_recording(metadata:)
        audio_variant = build_audio_variant(metadata:)
        waveform = build_waveform(waveform:)

        @audio_transfer.album = album
        @audio_transfer.transfer_agent = transfer_agent
        @audio_transfer.recording = recording
        @audio_transfer.waveform = waveform
        @audio_transfer.audio_file = audio_file

        @audio_transfer.audio_variants << audio_variant

        album.album_art.attach(io: File.open(album_art), filename: File.basename(album_art))
        audio_variant.audio_file.attach(io: File.open(compressed_audio), filename: File.basename(compressed_audio))
        waveform.image.attach(io: File.open(waveform_image), filename: File.basename(waveform_image))

        @audio_transfer
      end

      def find_or_initialize_album(metadata:)
        Album.find_or_initialize_by(title: metadata.album)
      end

      def find_or_initialize_transfer_agent(metadata:)
        TransferAgent.find_or_initialize_by(name: metadata.source)
      end

      def find_or_initialize_recording(metadata:)
        Recording.find_or_initialize_by(title: metadata.title) do |recording|
          recording.release_date = metadata.date
          recording.orchestra = find_or_initialize_orchestra(metadata:)
          recording.genre = find_or_initialize_genre(metadata:)
          recording.composition = find_or_initialize_composition(metadata:)
          recording.singers << find_or_initialize_singers(metadata:)
        end
      end

      def find_or_initialize_orchestra(metadata:)
        Orchestra.find_or_initialize_by(name: metadata.album_artist) do |orchestra|
          orchestra.sort_name = metadata.artist_sort
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
        Composer.find_or_initialize_by(name: metadata.composer)
      end

      def find_or_initialize_lyricist(metadata:)
        Lyricist.find_or_initialize_by(name: metadata.lyricist)
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
