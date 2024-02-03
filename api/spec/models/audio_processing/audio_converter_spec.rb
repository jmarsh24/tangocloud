require "rails_helper"

RSpec.describe AudioProcessing::AudioConverter do
  describe "#convert" do
    it "converts the file to the specified format and deletes it afterward" do
      converted_file_path = nil
      output_directory = "tmp/converted_audio"
      file = "spec/fixtures/audio/tone.mp3"

      AudioProcessing::AudioConverter.new(file:, output_directory: "tmp/converted_audio").convert do |output|
        expect(File.extname(output)).to eq(".aac")
        basename = File.basename(file, ".*")
        expect(output).to include(basename)
        expect(File.dirname(output)).to eq(output_directory)
        expect(output.start_with?(output_directory)).to be_truthy
        expect(File.exist?(output)).to be_truthy

        converted_file_path = output
      end

      expect(File.exist?(converted_file_path)).to be_falsey
    end

    it "removes all metadata from a flac file" do
      converted_file_path = nil
      file = "spec/fixtures/audio/19401008_volver_a_sonar_roberto_rufino_tango_2476.flac"

      AudioProcessing::AudioConverter.new(file:).convert do |output|
        extracted_metadata = AudioProcessing::MetadataExtractor.new(file: output).extract_metadata

        non_nil_keys = [:duration, :bit_rate, :sample_rate, :channels, :format, :bit_depth, :codec_name, :codec_long_name]

        non_nil_keys.each do |key|
          expect(extracted_metadata.public_send(key)).not_to be_nil
        end

        (AudioProcessing::MetadataExtractor::Metadata.members - non_nil_keys).each do |field|
          puts field
          expect(extracted_metadata.public_send(field)).to be_nil
        end
      end
    end
  end
end
