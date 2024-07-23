module ExternalCatalog
  module ElRecodo
    class SyncSongJob < ApplicationJob
      queue_as :background_sync

      limits_concurrency to: 1, key: "sync_song_job"

      def perform(ert_number:)
        ::ExternalCatalog::ElRecodo::SongSynchronizer.new.sync_song(ert_number:)
      rescue ExternalCatalog::ElRecodo::SongScraper::PageNotFoundError
      end
    end
  end
end
