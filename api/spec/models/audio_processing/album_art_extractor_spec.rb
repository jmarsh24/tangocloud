require "rails_helper"

RSpec.describe AudioProcessing::AlbumArtExtractor, type: :model do
  describe "#extract" do
    context "when the audio file has album art" do
      let(:file) { File.open(file_fixture("audio/19401008__volver_a_sonar__roberto_rufino__tango.flac")) }

      it "extracts the album art from the file" do
        album_art_extractor = AudioProcessing::AlbumArtExtractor.new(file:)
        album_art = album_art_extractor.extract

        expect(album_art).not_to be_nil
        expect(File.exist?(album_art.path)).to be true
        expect(File.size(album_art.path)).to be > 0
      end
    end
  end
end
