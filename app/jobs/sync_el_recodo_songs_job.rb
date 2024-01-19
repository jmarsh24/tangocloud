# frozen_string_literal: true

class SyncElRecodoSongsJob < ApplicationJob
  queue_as :background_sync

  def perform
    ElRecodoSong.sync_songs
  end
end
