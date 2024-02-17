require "rails_helper"

RSpec.describe AudioProcessing::AudioConverter do
  describe "#convert" do
    it "converts the file to the specified format and deletes it afterward" do
      file = File.open("spec/fixtures/audio/tone.mp3")
      output_path = nil

      AudioProcessing::AudioConverter.new(file).convert do |output|
        converted_movie = FFMPEG::Movie.new(output.path)
        expect(converted_movie.audio_codec).to eq("aac")
        output_path = output.path
      end

      expect(File.exist?(output_path)).to be_falsey unless Config.ci?
    end

    it "removes all metadata from a flac file" do
      file = File.open("spec/fixtures/audio/19401008_volver_a_sonar_roberto_rufino_tango_2476.flac")

      AudioProcessing::AudioConverter.new(file).convert do |output|
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
