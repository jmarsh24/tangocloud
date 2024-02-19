require "rails_helper"

RSpec.describe AudioProcessing::AlbumArtExtractor do
  describe "#extract" do
    context "when the audio file has album art" do
      it "extracts the album art from the file" do
        file = File.open("spec/fixtures/audio/19401008_volver_a_sonar_roberto_rufino_tango_2476.flac")
        saved_file = nil
        described_class.new(file).extract do |tempfile|
          saved_file = tempfile.path
          expect(File.exist?(tempfile.path)).to be true
          expect(File.size(tempfile.path)).to be > 0
        end
        expect(File.exist?(saved_file)).to be_falsy
      end
    end

    context "when the audio file does not have album art" do
      it "returns nil if the file does not have album art" do
        file = File.open("spec/fixtures/audio/19380307_tinta verde_instrumental_tango_no_thumbnail_2760.aif")
        expect(described_class.new(file).extract).to be_nil
      end
    end
  end
end
