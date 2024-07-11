class ExternalCatalog::ElRecodo::SyncSongJob < ApplicationJob
  queue_as :background_sync

  def perform(music_id:, interval: 0)
    sleep(interval)
    ::ExternalCatalog::ElRecodo::SongSynchronizer.new.sync_song(music_id:)
  rescue ExternalCatalog::ElRecodo::SongScraper::PageNotFoundError
  end
end
