module Import
  module Playlist
    class PlaylistImporter
      def initialize(playlist)
        @playlist = playlist
      end

      def import
        position = 1

        @playlist.playlist_file.blob.open do |file|
          file.each_line do |line|
            trimmed_line = line.strip
            match_data = trimmed_line.match(/^.*[\/\\]([^\/\\]+)\.(mp3|flac|m4a|wav|aiff|aif)$/i)

            next unless match_data
            filename = "#{match_data[1]}.#{match_data[2]}"

            audio_file = ::AudioFile.find_by(filename:)
            next unless audio_file

            recording = audio_file.digital_remaster.recording
            next unless recording

            @playlist.playlist_items.create!(
              item: recording,
              position:
            )

            position += 1
          end
        end

        @playlist
      end
    end
  end
end
