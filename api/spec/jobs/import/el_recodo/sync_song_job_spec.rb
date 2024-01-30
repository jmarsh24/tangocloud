# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::ElRecodo::SyncSongJob, type: :job do
  describe "#perform" do
    it "calls sync_song on SongSynchronizer with correct parameters" do
      music_id = 123
      song_synchronizer_instance = instance_double("Import::ElRecodo::SongSynchronizer")
      allow(Import::ElRecodo::SongSynchronizer).to receive(:new).and_return(song_synchronizer_instance)
      allow(song_synchronizer_instance).to receive(:sync_song)

      Import::ElRecodo::SyncSongJob.perform_now(music_id:)

      expect(Import::ElRecodo::SongSynchronizer).to have_received(:new)
      expect(song_synchronizer_instance).to have_received(:sync_song).with(music_id:)
    end

    it "does not raise an error if SongScraper::PageNotFoundError is raised" do
      music_id = 123
      song_synchronizer_instance = instance_double("Import::ElRecodo::SongSynchronizer")
      allow(Import::ElRecodo::SongSynchronizer).to receive(:new).and_return(song_synchronizer_instance)
      allow(song_synchronizer_instance).to receive(:sync_song).and_raise(Import::ElRecodo::SongScraper::PageNotFoundError)
      expect { Import::ElRecodo::SyncSongJob.perform_now(music_id:) }.not_to raise_error
    end
  end
end
