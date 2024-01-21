# frozen_string_literal: true

class Import::ElRecodo::SyncSongsJob < ApplicationJob
  queue_as :background_sync

  def perform
    ::Import::ElRecodo::SongSynchronizer.new.sync_songs
  end
end
