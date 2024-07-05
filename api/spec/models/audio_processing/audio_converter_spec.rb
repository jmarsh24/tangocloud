require "rails_helper"

RSpec.describe AudioProcessing::AudioConverter do
  let(:file) { File.open(file_fixture("audio/19401008__volver_a_sonar__roberto_rufino__tango.flac")) }
  let!(:converted_audio) { AudioProcessing::AudioConverter.new(file:).convert }

  describe "#convert" do
    it "converts the file to the specified format and deletes it afterward" do
      converted_movie = FFMPEG::Movie.new(converted_audio.path)

      # Make sure the file is converted to the correct format
      expect(converted_movie.audio_codec).to eq("aac")

      # Make sure metadata is removed from file
      extracted_metadata = AudioProcessing::MetadataExtractor.new(file: converted_audio).extract

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
