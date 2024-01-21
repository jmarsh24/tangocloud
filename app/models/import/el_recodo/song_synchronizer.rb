# frozen_string_literal: true

module Import
  module ElRecodo
    class SongSynchronizer
      def sync_songs(from: 1, to: 20_000, interval: 30)
        GoodJob::Bulk.enqueue do
          (from..to).map do |music_id|
            ::Import::ElRecodo::SyncSongJob.perform_later(music_id:, interval:)
          end
        end
      end

      def sync_song(music_id:)
        song_metadata = SongScraper.new(music_id:).metadata
        ::ElRecodoSong.find_or_initialize_by(music_id:).tap do |song|
          song.update!(song_metadata.to_h)
        end
      rescue => e
        puts "Failed to sync song with ID #{music_id}: #{e.message}"
        raise e
      end
    end
  end
end
