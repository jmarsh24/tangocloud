module ExternalCatalog
  module ElRecodo
    class SyncExistingSongsJob < ApplicationJob
      queue_as :background_sync

      limits_concurrency to: 3, key: -> { "sync_songs" }, duration: 1.minute

      def perform
        Song.pluck(:ert_number).each do |ert_number|
          SyncSongJob.perform_later(ert_number:)
        end
      end
    end
  end
end
