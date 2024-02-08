require "rails_helper"

RSpec.describe AudioProcessing::AlbumArtExtractor do
  describe "#extract" do
    context "when the audio file has album art" do
      it "extracts the album art from the file" do
        file = Rails.root.join("spec", "fixtures", "audio", "19401008_volver_a_sonar_roberto_rufino_tango_2476.flac")
        saved_file = nil
        described_class.new(file:).extract do |tempfile|
          saved_file = tempfile.path
          expect(tempfile.path).to match(/album_art/)
          expect(tempfile.path).to match(/.jpg/)
          expect(File.exist?(tempfile.path)).to be true
          expect(File.size(tempfile.path)).to be > 0
        end
        expect(File.exist?(saved_file)).to be_falsy
      end

      it "returns the path to the extracted album art and is persisted" do
        file = Rails.root.join("spec", "fixtures", "audio", "19401008_volver_a_sonar_roberto_rufino_tango_2476.flac")
        album_art_path = described_class.new(file:).extract
        expect(album_art_path).to match("/tmp/19401008_volver_a_sonar_roberto_rufino_tango_2476.jpg")
        expect(File.exist?(album_art_path)).to be true
        expect(File.size(album_art_path)).to be > 0
      end
    end

    context "when the audio file does not have album art" do
      it "returns nil if the file does not have album art" do
        file = Rails.root.join("spec", "fixtures", "audio", "19380307_tinta verde_instrumental_tango_no_thumbnail_2760.aif")
        expect(described_class.new(file:).extract).to be_nil
      end
    end
  end
end
