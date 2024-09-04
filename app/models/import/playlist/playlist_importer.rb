module Import
  module Playlist
    class PlaylistImporter
      def initialize(playlist)
        @playlist = playlist
      end

      def import
        position = 1

        @playlist.playlist_file.blob.open do |file|
          recordings = AudioFileMatcher.new(file).recordings

          recordings.each do |recording|
            @playlist.playlist_items.create!(
              item: recording,
              position:
            )

            position += 1
          end

          @playlist
        end
      end
    end
  end
end
