class ExternalCatalog::ElRecodo::SyncSongJob < ApplicationJob
  queue_as :background_sync

  def perform(ert_number:)
    ::ExternalCatalog::ElRecodo::SongSynchronizer.new.sync_song(ert_number:)
  rescue ExternalCatalog::ElRecodo::SongScraper::PageNotFoundError
  end
end
