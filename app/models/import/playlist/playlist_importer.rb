module Import
  module Playlist
    class PlaylistImporter
      def initialize(playlist)
        @playlist = playlist
      end

      def import
        if @playlist.import_as_tandas
          PlaylistTandaImporter.new(@playlist).import
        else
          row_order = 1

          @playlist.playlist_file.blob.open do |file|
            recordings = AudioFileMatcher.new(file).recordings
            recordings.each do |recording|
              @playlist.playlist_items.create!(
                item: recording,
                row_order:
              )
              row_order += 1
            end
          end

          @playlist
        end
      end
    end
  end
end
