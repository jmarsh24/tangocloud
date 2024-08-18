require "rails_helper"

RSpec.describe Import::AudioFile::Importer do
  describe "#sync" do
    it "imports all audio files from the specified directory" do
      directory_path = Rails.root.join("spec/fixtures/files/audio")

      Import::AudioFile::Importer.new(directory_path).sync

      expect(AudioFile.count).to eq(5)
    end

    it "skips files that are not supported" do
      AudioFile.create!(filename: "19390201__enrique_rodriguez__te_quiero_ver_escopeta__roberto_flores__tango__TC6612_TT.flac", format: "flac")

      directory_path = Rails.root.join("spec/fixtures/files/audio")

      expect do
        Import::AudioFile::Importer.new(directory_path).sync
      end.to change(AudioFile, :count).by(4)
    end
  end
end
