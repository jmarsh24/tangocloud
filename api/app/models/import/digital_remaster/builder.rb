module Import
  module DigitalRemaster
    class Builder
      def initialize
        @digital_remaster = ::DigitalRemaster.new
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

      def build_digital_remaster(audio_file:, metadata:, waveform:, waveform_image:, album_art:, compressed_audio:)
        album = find_or_initialize_album(metadata:)
        remaster_agent = find_or_initialize_remaster_agent(metadata:)
        composition = find_or_initialize_composition(metadata:)
        recording = build_new_recording(metadata:, composition:)
        audio_variant = build_audio_variant(metadata:)
        waveform = build_waveform(waveform:)

        @digital_remaster.album = album
        @digital_remaster.remaster_agent = remaster_agent
        @digital_remaster.recording = recording
        @digital_remaster.waveform = waveform
        @digital_remaster.audio_file = audio_file

        @digital_remaster.audio_variants << audio_variant

        album.album_art.attach(io: File.open(album_art), filename: File.basename(album_art))
        audio_variant.audio_file.attach(io: File.open(compressed_audio), filename: File.basename(compressed_audio))
        waveform.image.attach(io: File.open(waveform_image), filename: File.basename(waveform_image))

        @digital_remaster
      end

      def find_or_initialize_album(metadata:)
        Album.find_or_initialize_by(title: metadata.album)
      end

      def find_or_initialize_remaster_agent(metadata:)
        RemasterAgent.find_or_initialize_by(name: metadata.source)
      end

      def build_recording(metadata:)
        Recording.new(
          composition: find_or_initialize_composition(metadata:),
          recorded_date: metadata.date,
          orchestra: find_or_initialize_orchestra(metadata:),
          genre: find_or_initialize_genre(metadata:),
          singers: find_or_initialize_singers(metadata:)
        )
      end

      def find_or_initialize_orchestra(metadata:)
        Orchestra.find_or_initialize_by(name: metadata.album_artist) do |orchestra|
          orchestra.sort_name = metadata.artist_sort
        end
      end

      def find_or_initialize_singers(metadata:)
        metadata.artist.map do |singer_name|
          Person.find_or_initialize_by(name: singer_name)
        end
      end

      def find_or_initialize_genre(metadata:)
        Genre.find_or_initialize_by(name: metadata.genre)
      end

      def find_or_initialize_composer(metadata:)
        Person.find_or_initialize_by(name: metadata.composer)
      end

      def find_or_initialize_lyricist(metadata:)
        Person.find_or_initialize_by(name: metadata.lyricist)
      end

      def find_or_initialize_composition(metadata:)
        composition = Composition.find_or_initialize_by(title: metadata.title) do |comp|
          comp.composers << find_or_initialize_composer(metadata:)
          comp.lyricists << find_or_initialize_lyricist(metadata:)
        end
        find_or_initialize_lyrics(metadata:, composition:)
        composition
      end

      def find_or_initialize_lyrics(metadata:, composition:)
        return if metadata.lyrics.blank?

        composition.lyrics.find_or_initialize_by(text: metadata.lyrics) do |lyric|
          lyric.language = Language.find_or_initialize_by(name: "es")
        end
      end
    end
  end
end
