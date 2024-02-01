require "rails_helper"

RSpec.describe AudioProcessing::CoverArtExtractor do
  describe "#extract_cover_art" do
    it "extracts the cover art from the file" do
      file = Rails.root.join("spec", "fixtures", "audio", "19380307_comme_il_faut_instrumental_tango_2758.aif")
      described_class.new(file:).extract_cover_art do |tempfile|
        expect(tempfile.path).to match(/cover_art/)
        expect(tempfile.path).to match(/.jpg/)
        expect(File.exist?(tempfile.path)).to be true
        expect(File.size(tempfile.path)).to be > 0
      end
    end
  end
end
