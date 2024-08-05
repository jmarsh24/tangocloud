require "rails_helper"

RSpec.describe AudioProcessing::AudioConverter do
  let(:file) { File.open(file_fixture("audio/raw/19390201__enrique_rodriguez__te_quiero_ver_escopeta__roberto_flores__tango__TC6612_TT.flac")) }

  describe "#convert" do
    it "converts the file to the specified format and deletes it afterward" do
      AudioProcessing::AudioConverter.new.convert(file:) do |converted_audio|
        converted_movie = FFMPEG::Movie.new(converted_audio.path)

        expect(converted_movie.audio_codec).to eq("mp3")

        extracted_metadata = AudioProcessing::MetadataExtractor.new.extract(file: converted_audio)

        non_nil_keys = [:duration, :bit_rate, :sample_rate, :channels, :format, :bit_depth, :codec_name]

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
