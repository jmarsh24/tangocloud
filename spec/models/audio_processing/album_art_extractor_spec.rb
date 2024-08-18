require "rails_helper"

RSpec.describe AudioProcessing::AlbumArtExtractor, type: :model do
  describe "#extract" do
    context "when the audio file has album art" do
      let(:file) { File.open(file_fixture("audio/raw/19390201__enrique_rodriguez__te_quiero_ver_escopeta__roberto_flores__tango__TC6612_TT.flac")) }

      it "extracts the album art from the file" do
        AudioProcessing::AlbumArtExtractor.new.extract(file.path) do |album_art|
          expect(album_art).not_to be_nil
          expect(File.exist?(album_art.path)).to be true
          expect(File.size(album_art.path)).to be > 0
        end
      end
    end
  end
end
