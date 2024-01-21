# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::ElRecodo::SyncSongJob, type: :job do
  describe "#perform" do
    it "calls sync_song on SongSynchronizer with correct parameters" do
      music_id = 123
      interval = 5
      song_synchronizer_instance = instance_double("Import::ElRecodo::SongSynchronizer")
      allow(Import::ElRecodo::SongSynchronizer).to receive(:new).and_return(song_synchronizer_instance)
      allow(song_synchronizer_instance).to receive(:sync_song)

      Import::ElRecodo::SyncSongJob.perform_now(music_id:, interval:)

      expect(Import::ElRecodo::SongSynchronizer).to have_received(:new)
      expect(song_synchronizer_instance).to have_received(:sync_song).with(music_id:)
    end
  end
end
