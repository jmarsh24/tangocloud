module Import
  module Playlist
    class PlaylistImporter
      def initialize(playlist_file, user: nil)
        @playlist_file = playlist_file
        @user = user
      end

      def import
        position = 1
        title = File.basename(@playlist_file, ".*")
        playlist = ::Playlist.create!(title: title, user: @user)

        File.foreach(@playlist_file) do |line|
          trimmed_line = line.strip
          match_data = trimmed_line.match(/^.*\/([^\/]+)\.(mp3|flac|m4a|wav|aiff|aif)$/i)
          next unless match_data

          filename_with_extension = "#{match_data[1]}.#{match_data[2]}"

          audio_transfer = AudioTransfer.find_by(filename: filename_with_extension)
          next unless audio_transfer

          playlist.playlist_audio_transfers.create!(
            audio_transfer: audio_transfer,
            position: position
          )

          position += 1
        end
        playlist
      end
    end
  end
end
