require "rails_helper"

RSpec.describe Import::Music::DirectoryImporter do
  describe "#import" do
    let(:importer) { Import::Music::DirectoryImporter.new("spec/fixtures/audio") }
    let(:song_importer_double) { instance_double("Import::Music::SongImporter", import: true) }

    before do
      allow(Import::Music::SongImporter).to receive(:new).and_return(song_importer_double)
    end

    it "calls SongImporter#import the correct number of times for supported files" do
      importer.import
      expect(Import::Music::SongImporter).to have_received(:new).exactly(2).times
    end

    it "does not import unsupported files" do
      importer = Import::Music::DirectoryImporter.new("spec/fixtures/images")
      importer.import
      expect(Import::Music::SongImporter).not_to have_received(:new)
    end
  end
end
