class ExternalCatalog::ElRecodo::SyncSongsJob < ApplicationJob
  queue_as :background_sync

  limits_concurrency to: 3, key: -> { "sync_songs" }, duration: 1.minute

  def perform
    ElRecodoSong.pluck(:ert_number).each do |ert_number|
      ExternalCatalog::ElRecodo::SyncSongJob.perform_later(ert_number:)
    end
  end
end
