module Import
  module DigitalRemaster
    class Builder
      RecordingMetadata = Data.define(
        :date,
        :barcode,
        :artist,
        :composer,
        :lyricist,
        :title,
        :orchestra_name,
        :conductor,
        :musicians,
        :genre,
        :organization,
        :lyrics
      ).freeze

      ROLE_TRANSLATION = {
        "piano" => "Pianist",
        "arranger" => "Arranger",
        "doublebass" => "Double Bassist",
        "bandoneon" => "Bandoneonist",
        "violin" => "Violinist",
        "singer" => "Vocalist",
        "soloist" => "Soloist",
        "director" => "Conductor",
        "composer" => "Composer",
        "author" => "Lyricist",
        "cello" => "Cellist"
      }.freeze

      def initialize
        @digital_remaster = ::DigitalRemaster.new
        @audio_file_processor = AudioFileProcessor.new
      end

      def build(audio_file:, metadata:, waveform:, waveform_image:, album_art:, compressed_audio:)
        @digital_remaster.duration = metadata.duration
        @digital_remaster.replay_gain = metadata.replaygain_track_gain.to_f
        @digital_remaster.peak_value = metadata.replaygain_track_peak.to_f
        @digital_remaster.tango_cloud_id = metadata.catalog_number&.split("TC")&.last.to_i
        @digital_remaster.album = build_album(metadata:, album_art:)
        @digital_remaster.remaster_agent = build_remaster_agent(metadata:)
        @digital_remaster.recording = build_recording(metadata:)
        @digital_remaster.waveform = build_waveform(waveform:, waveform_image:)
        @digital_remaster.audio_file = audio_file
        @digital_remaster.audio_variants << build_audio_variant(format:, bit_rate:, compressed_audio:)
        @digital_remaster
      end

      private

      def build_recording(metadata:)
        recording_metadata = RecordingMetadata.new(
          date: metadata.date,
          barcode: metadata.barcode,
          artist: metadata.artist,
          composer: metadata.composer,
          lyricist: metadata.lyricist,
          title: metadata.title,
          orchestra_name: metadata.orchestra_name,
          conductor: metadata.conductor,
          musicians: metadata.musicians,
          genre: metadata.genre,
          organization: metadata.organization,
          lyrics: metadata.lyrics
        )
        Builders::RecordingBuilder.new(recording_metadata:).build
      end

      def build_waveform(waveform:, waveform_image:)
        waveform = Waveform.new(
          version: waveform.version,
          channels: waveform.channels,
          sample_rate: waveform.sample_rate,
          samples_per_pixel: waveform.samples_per_pixel,
          bits: waveform.bits,
          length: waveform.length,
          data: waveform.data
        )
        waveform.image.attach(io: File.open(waveform_image), filename: File.basename(waveform_image))
      end

      def build_audio_variant(format:, bit_rate:, compressed_audio:)
        audio_variant = AudioVariant.new(
          format: metadata.format,
          bit_rate: metadata.bit_rate
        )
        audio_variant.audio_file.attach(io: File.open(compressed_audio), filename: File.basename(compressed_audio))
        audio_variant
      end

      def build_album(album_title:, album_art:)
        return if album_title.blank?

        Album.find_or_create_by!(title: metadata.album)
        album.album_art.attach(io: File.open(album_art), filename: File.basename(album_art))
      end

      def build_remaster_agent(name:)
        return if name.blank?

        RemasterAgent.find_or_create_by!(name: metadata.organization)
      end
    end
  end
end
