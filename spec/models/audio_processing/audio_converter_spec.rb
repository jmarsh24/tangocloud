# frozen_string_literal: true

require "rails_helper"

RSpec.describe AudioProcessing::AudioConverter do
  let(:test_file_path) { "spec/fixtures/tone.mp3" }
  let(:converter) { AudioProcessing::AudioConverter.new(file: test_file_path) }
  let(:fake_movie) { instance_double(FFMPEG::Movie) }

  before do
    allow(FFMPEG::Movie).to receive(:new).and_return(fake_movie)
    allow(fake_movie).to receive(:transcode).and_return(true)
  end

  describe "#convert" do
    it "converts the file to the specified format" do
      output = converter.convert
      expect(File.extname(output)).to eq(".aac")
      expect(FFMPEG::Movie).to have_received(:new).with(test_file_path)
      expect(fake_movie).to have_received(:transcode)
    end

    it "generates an output filename based on the input filename and timestamp" do
      output = converter.convert
      basename = File.basename(test_file_path, ".*")
      expect(output).to include(basename)
      expect(output).to match(/\d{14}/)
    end
  end
end
