module Import
  module Playlist
    class MilongaImporter
      def initialize(playlist)
        @playlist = playlist
      end

      def import
        position = 1

        @playlist.playlist_file.blob.open do |file|
          recordings = AudioFileMatcher.new(file).recordings
          grouped_recordings = group_recordings_by_orchestra_in_order(recordings)

          grouped_recordings.each do |recording_group|
            if recording_group.size == 1
              @playlist.playlist_items.create!(
                item: recording_group.first,
                position:
              )
            else
              tanda = Tanda.create!(title: "Playlist #{@playlist.title} Tanda #{position}")

              recording_group.each do |recording|
                tanda.recordings << recording
              end

              @playlist.playlist_items.create!(
                item: tanda,
                position:
              )
            end

            position += 1
          end
        end

        @playlist
      end

      private

      def group_recordings_by_orchestra_in_order(recordings)
        groups = []
        current_orchestra = nil
        current_tanda = []

        recordings.each do |recording|
          if current_orchestra && current_orchestra != recording.orchestra
            groups << current_tanda unless current_tanda.empty?
            current_tanda = []
          end
          current_orchestra = recording.orchestra
          current_tanda << recording
        end

        groups << current_tanda unless current_tanda.empty?
        groups
      end
    end
  end
end
