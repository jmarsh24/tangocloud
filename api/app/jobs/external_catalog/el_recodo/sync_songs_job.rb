class ExternalCatalog::ElRecodo::SyncSongsJob < ApplicationJob
  queue_as :background_sync

  def perform
    ::ExternalCatalog::ElRecodo::SongSynchronizer.new.sync_songs
  end
end
