module Import
  module DigitalRemaster
    class Builder
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
        album = build_album(metadata:)
        remaster_agent = build_remaster_agent(metadata:)
        recording = build_recording(metadata:)
        audio_variant = build_audio_variant(metadata:)
        waveform = build_waveform(waveform:)
        @digital_remaster.duration = metadata.duration
        @digital_remaster.replay_gain = metadata.replaygain_track_gain.to_f
        @digital_remaster.peak_value = metadata.replaygain_track_peak.to_f
        @digital_remaster.tango_cloud_id = metadata.catalog_number&.split("TC")&.last.to_i
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

      private

      def build_audio_variant(metadata:)
        return if metadata.format.blank?

        AudioVariant.new(
          format: metadata.format,
          bit_rate: metadata.bit_rate
        )
      end

      def build_waveform(waveform:)
        return if waveform.blank?

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

      def build_recording(metadata:)
        RecordingBuilder.new(metadata).build
      end

      def build_album(metadata:)
        return if metadata.album.blank?

        Album.find_or_create_by!(title: metadata.album)
      end

      def build_remaster_agent(metadata:)
        return if metadata.organization.blank?

        RemasterAgent.find_or_create_by!(name: metadata.organization)
      end
    end
  end
end
