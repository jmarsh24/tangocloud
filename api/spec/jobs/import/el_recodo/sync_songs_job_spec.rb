require "rails_helper"

RSpec.describe ExternalCatalog::ElRecodo::SyncSongsJob, type: :job do
  describe "#perform" do
    it "calls sync_songs on SongSynchronizer" do
      song_synchronizer_instance = instance_double("ExternalCatalog::ElRecodo::SongSynchronizer")
      allow(ExternalCatalog::ElRecodo::SongSynchronizer).to receive(:new).and_return(song_synchronizer_instance)

      expect(song_synchronizer_instance).to receive(:sync_songs)
      ExternalCatalog::ElRecodo::SyncSongsJob.perform_now
    end
  end
end
