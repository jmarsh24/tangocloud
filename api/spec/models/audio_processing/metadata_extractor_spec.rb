require "rails_helper"

RSpec.describe AudioProcessing::MetadataExtractor do
  describe "#extract" do
    it "returns a hash of metadata for flac" do
      file = File.open(file_fixture("audio/19401008__volver_a_sonar__roberto_rufino__tango.flac"))
      metadata = AudioProcessing::MetadataExtractor.new(file:).extract

      expect(metadata.title).to eq("Volver a soñar")
      expect(metadata.artist).to eq("Roberto Rufino")
      expect(metadata.album).to eq("TT - Todo de Carlos -1939-1941 [FLAC]")
      expect(metadata.date).to eq("1940-10-08")
      expect(metadata.genre).to eq("Tango")
      expect(metadata.album_artist).to eq("Carlos Di Sarli")
      expect(metadata.catalog_number).to be_nil
      expect(metadata.composer).to eq("Andrés Fraga")
      expect(metadata.lyrics).to be_present
      expect(metadata.duration).to eq(165.158396)
      expect(metadata.bit_rate).to eq(1325044)
      expect(metadata.codec_name).to eq("flac")
      expect(metadata.codec_long_name).to eq("FLAC (Free Lossless Audio Codec)")
      expect(metadata.sample_rate).to eq(96000)
      expect(metadata.channels).to eq(1)
      expect(metadata.bit_depth).to eq(24)
      expect(metadata.format).to eq("flac")
      expect(metadata.ert_number).to eq("ERT-2476")
      expect(metadata.grouping).to eq("FREE")
      expect(metadata.publisher).to be_nil
      expect(metadata.lyricist).to eq("Francisco García Jiménez")
      expect(metadata.album_artist_sort).to be_nil
      expect(metadata.catalog_number).to be_nil
    end
  end
end
