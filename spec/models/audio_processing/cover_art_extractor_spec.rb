# frozen_string_literal: true

require "rails_helper"

RSpec.describe AudioProcessing::CoverArtExtractor do
  describe "#extract_cover_art" do
    it "extracts the cover art from the file" do
      file = Rails.root.join("spec", "fixtures", "029_-_Nunca_tuvo_novio.aif")
      described_class.new(file:).extract_cover_art do |tempfile|
        expect(tempfile.path).to match(/cover_art/)
        expect(tempfile.path).to match(/.jpg/)
        expect(File.exist?(tempfile.path)).to be true
        expect(File.size(tempfile.path)).to be > 0
      end
    end
  end
end
