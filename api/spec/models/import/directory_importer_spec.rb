require "rails_helper"

RSpec.describe Import::DirectoryImporter do
  describe "#sync" do
    it "creates 6 AudioTransfers and enqueues AudioTransferImportJob 5 times for supported files" do
      directory_path = Rails.root.join("spec/fixtures/files/audio")

      Import::DirectoryImporter.new(directory_path).sync

      expect(AudioFileImportJob).to have_been_enqueued.exactly(6).times
    end

    it "does not import files that are already in the database" do
      create(:audio_file, :flac)

      directory_path = Rails.root.join("spec/fixtures/files/audio")

      Import::DirectoryImporter.new(directory_path).sync

      expect(AudioFileImportJob).to have_been_enqueued.exactly(5).times
    end
  end
end