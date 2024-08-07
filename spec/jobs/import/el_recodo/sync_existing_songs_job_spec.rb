require "rails_helper"

RSpec.describe ExternalCatalog::ElRecodo::SyncExistingSongsJob, type: :job do
  describe "#perform" do
    let!(:songs) { create_list(:external_catalog_el_recodo_song, 3) } # Create some test data

    it "queues a SyncSongJob for each song" do
      songs.each do |song|
        expect(ExternalCatalog::ElRecodo::SyncSongJob).to receive(:perform_later).with(ert_number: song.ert_number)
      end

      ExternalCatalog::ElRecodo::SyncExistingSongsJob.perform_now
    end
  end
end
