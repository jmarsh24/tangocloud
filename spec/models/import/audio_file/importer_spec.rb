require "rails_helper"

RSpec.describe Import::AudioFile::Importer do
  describe "#sync" do
    it "creates 6 DigitalRemasters and enqueues AudioFileImportJob 5 times for supported files" do
      directory_path = Rails.root.join("spec/fixtures/files/audio")

      Import::AudioFile::Importer.new(directory_path).sync

      expect(Import::AudioFile::ImportJob).to have_been_enqueued.exactly(5).times
    end

    it "does not import files that are already in the database" do
      create(:audio_file, :flac)

      directory_path = Rails.root.join("spec/fixtures/files/audio")

      Import::AudioFile::Importer.new(directory_path).sync

      expect(Import::AudioFile::ImportJob).to have_been_enqueued.exactly(4).times
    end
  end
end
