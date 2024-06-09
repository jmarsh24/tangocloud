require "rails_helper"

RSpec.describe Import::Music::DirectoryImporter do
  let(:directory_path) { "spec/fixtures/audio" }
  let(:importer) { described_class.new(directory_path) }

  describe "#import" do
    it "creates 6 AudioTransfers and enqueues AudioTransferImportJob 6 times for supported files" do
      AudioTransfer.destroy_all
      importer.import

      expect(AudioTransfer.count).to eq(7)

      expect(AudioTransferImportJob).to have_been_enqueued.exactly(7).times
    end
  end

  describe "#sync" do
    it "creates 6 AudioTransfers and enqueues AudioTransferImportJob 6 times for supported files" do
      importer.sync

      expect(AudioTransferImportJob).to have_been_enqueued.exactly(6).times
    end
  end
end
