# frozen_string_literal: true

class Import::ElRecodo::SyncSongsJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency
  queue_as :background_sync
  good_job_control_concurrency_with(perform_limit: 1, key: "el_recodo_sync_songs")

  def perform
    ::Import::ElRecodo::SongSynchronizer.new.sync_songs
  end
end
