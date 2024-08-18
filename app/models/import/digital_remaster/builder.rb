module Import
  module DigitalRemaster
    class Builder
      RecordingMetadata = Data.define(
        :title,
        :artist,
        :year,
        :genre,
        :album_artist,
        :album_artist_sort,
        :composer,
        :grouping,
        :catalog_number,
        :lyricist,
        :barcode,
        :date,
        :organization,
        :lyrics
      ).freeze

      def initialize(audio_file:, metadata:, waveform:, waveform_image:, album_art:, compressed_audio:)
        @audio_file = audio_file
        @metadata = metadata
        @waveform = waveform
        @waveform_image = waveform_image
        @album_art = album_art
        @compressed_audio = compressed_audio
        @digital_remaster = ::DigitalRemaster.new
      end

      def build
        @digital_remaster.duration = @metadata.duration
        @digital_remaster.replay_gain = @metadata.replaygain_track_gain.to_f
        @digital_remaster.peak_value = @metadata.replaygain_track_peak.to_f
        @digital_remaster.tango_cloud_id = @metadata.catalog_number&.split("TC")&.last.to_i
        @digital_remaster.album = build_album(title: @metadata.album, album_art: @album_art)
        @digital_remaster.remaster_agent = build_remaster_agent(name: @metadata.grouping)
        @digital_remaster.recording = build_recording(metadata: @metadata)
        @digital_remaster.waveform = build_waveform(waveform: @waveform, waveform_image: @waveform_image)
        @digital_remaster.audio_file = @audio_file
        @digital_remaster.audio_variants << build_audio_variant(
          format: @metadata.format,
          bit_rate: @metadata.bit_rate,
          compressed_audio: @compressed_audio
        )
        @digital_remaster
      end

      private

      def build_recording(metadata:)
        recording_metadata = RecordingMetadata.new(
          title: metadata.title,
          artist: metadata.artist,
          year: metadata.year,
          genre: metadata.genre,
          album_artist: metadata.album_artist,
          album_artist_sort: metadata.album_artist_sort,
          composer: metadata.composer,
          grouping: metadata.grouping,
          catalog_number: metadata.catalog_number,
          lyricist: metadata.lyricist,
          barcode: metadata.barcode,
          date: metadata.date,
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
        waveform
      end

      def build_audio_variant(format:, bit_rate:, compressed_audio:)
        audio_variant = AudioVariant.new(
          format:,
          bit_rate:
        )
        audio_variant.audio_file.attach(io: File.open(compressed_audio), filename: File.basename(compressed_audio))
        audio_variant
      end

      def build_album(title:, album_art:)
        return if title.blank?

        album = Album.find_or_create_by!(title:)

        if album_art.present? && !album.album_art.attached?
          album.album_art.attach(io: File.open(album_art), filename: File.basename(album_art))
        end

        album
      end

      def build_remaster_agent(name:)
        return if name.blank?

        RemasterAgent.find_or_create_by!(name:)
      end
    end
  end
end
