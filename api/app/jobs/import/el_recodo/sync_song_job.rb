class Import::ElRecodo::SyncSongJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency
  queue_as :background_sync

  def perform(music_id:, interval: 0)
    sleep(interval)
    ::Import::ElRecodo::SongSynchronizer.new.sync_song(music_id:)
  rescue Import::ElRecodo::SongScraper::PageNotFoundError
  end
end
