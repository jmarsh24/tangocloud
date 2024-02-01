require "rails_helper"

RSpec.describe AudioProcessing::AudioConverter do
  let(:test_file_path) { "spec/fixtures/audio/tone.mp3" }
  let(:output_directory) { "tmp/converted_audio_files" }
  let(:converter) { AudioProcessing::AudioConverter.new(file: test_file_path, output_directory:) }

  describe "#convert" do
    it "converts the file to the specified format and deletes it afterward" do
      converted_file_path = nil

      converter.convert do |output|
        expect(File.extname(output)).to eq(".aac")
        basename = File.basename(test_file_path, ".*")
        expect(output).to include(basename)
        expect(File.dirname(output)).to eq(output_directory)
        expect(output.start_with?(output_directory)).to be_truthy
        expect(File.exist?(output)).to be_truthy

        converted_file_path = output
      end

      expect(File.exist?(converted_file_path)).to be_falsey
    end
  end
end
