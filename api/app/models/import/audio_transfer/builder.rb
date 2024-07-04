module Import
  module AudioTransfer
    class Builder
      def initialize(audio_file:)
        @audio_file = audio_file
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
          recording.genre = find_or_initialize_genre(metadata:)
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
        Genre.find_or_initialize_by(name: metadata.genre) do |genre|
          genre.description = metadata.genre_description
        end
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
          lyric.locale = metadata.lyric_locale || "en"
        end
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

      def build_waveform(waveform_data)
        Waveform.new(waveform_data)
      end

      def build_audio_transfer(filename:, album:, transfer_agent:, recording:, audio_variant:, waveform:)
        AudioTransfer.new(
          filename:,
          album:,
          transfer_agent:,
          recording:,
          audio_variant:,
          waveform:
        )
      end

      def update_audio_file_status(status)
        @audio_file.update!(status:)
      end
    end
  end
end
