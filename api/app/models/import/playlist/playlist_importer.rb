module Import
  module Playlist
    class PlaylistImporter
      def initialize(playlist_file, user: nil, title: nil)
        @playlist_file = playlist_file
        @user = user
        @title = title
      end

      def import
        position = 1
        title = @title || File.basename(@playlist_file, ".*")
        playlist = ::Playlist.create!(title:, user: @user)

        File.foreach(@playlist_file) do |line|
          trimmed_line = line.strip
          match_data = trimmed_line.match(/^.*[\/\\]([^\/\\]+)\.(mp3|flac|m4a|wav|aiff|aif)$/i)

          next unless match_data
          filename = "#{match_data[1]}.#{match_data[2]}"
          audio_transfer = AudioTransfer.find_by(filename:)
          next unless audio_transfer

          playlist.playlist_audio_transfers.create!(
            audio_transfer:,
            position:
          )

          position += 1
        end
        playlist
      end
    end
  end
end
