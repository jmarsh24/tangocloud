module Import
  module Playlist
    class PlaylistTandaImporter
      def initialize(playlist)
        @playlist = playlist
      end

      def import
        position = 1

        @playlist.playlist_file.blob.open do |path|
          recordings = AudioFileMatcher.new(path).recordings
          grouped_recordings = Playlist::RecordingsGrouper.group(recordings)

          grouped_recordings.each do |recording_group|
            if recording_group.size == 1
              @playlist.playlist_items.create!(
                item: recording_group.first,
                position: position
              )
            else
              tanda_title = Playlist::TandaTitleGenerator.generate(recording_group, position)
              tanda = Tanda.create!(title: tanda_title)
              tanda.attach_default_image

              tanda.recordings << recording_group

              @playlist.playlist_items.create!(
                item: tanda,
                position: position
              )
            end

            position += 1
          end
        end

        @playlist
      end
    end
  end
end
