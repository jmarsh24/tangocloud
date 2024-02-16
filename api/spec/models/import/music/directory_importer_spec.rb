require "rails_helper"

RSpec.describe Import::Music::DirectoryImporter do
  describe "#import" do
    let(:directory_path) { "spec/fixtures/audio" }
    let(:importer) { Import::Music::DirectoryImporter.new(directory_path) }
    let(:audio_transfer_importer_double) { instance_double("Import::Music::AudioTransferImporter") }

    before do
      allow(Import::Music::AudioTransferImporter).to receive(:new).and_return(audio_transfer_importer_double)
      allow(audio_transfer_importer_double).to receive(:import_from_file).and_return(true)
    end

    it "calls AudioTransferImporter#import_from_file the correct number of times for supported files" do
      expected_file_count = Dir.glob(File.join(directory_path, "*.{mp3,aif,flac,mp4,mpeg,m4a}")).count
      importer.import
      expect(audio_transfer_importer_double).to have_received(:import_from_file).exactly(expected_file_count).times
    end
  end
end
