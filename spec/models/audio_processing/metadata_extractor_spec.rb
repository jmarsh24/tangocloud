require "rails_helper"

RSpec.describe AudioProcessing::MetadataExtractor do
  describe "#extract" do
    it "returns correct metadata for normal mp3" do
      file = File.open(file_fixture("audio/raw/19390201__enrique_rodriguez__te_quiero_ver_escopeta__roberto_flores__tango__TC6612_TT.flac"))
      metadata = AudioProcessing::MetadataExtractor.new.extract(file:)

      expect(metadata.title).to eq("Te quiero ver escopeta")
      expect(metadata.artist).to eq("Roberto Flores")
      expect(metadata.album).to eq("TT - Todo de Enrique - Enrique Rodríguez Flores Reyes et al (1938-1960) [FLAC]")
      expect(metadata.year).to eq("1939")
      expect(metadata.genre).to eq("Tango")
      expect(metadata.album_artist).to eq("Enrique Rodríguez")
      expect(metadata.album_artist_sort).to eq("Rodríguez, Enrique")
      expect(metadata.composer).to eq("Enrique Rodríguez")
      expect(metadata.grouping).to eq("Tango Tunes")
      expect(metadata.catalog_number).to eq("TC6612")
      expect(metadata.lyricist).to eq("Alfredo Bigeschi")
      expect(metadata.barcode).to eq("ERT-4552")
      expect(metadata.date).to eq("1939-02-01")
      expect(metadata.duration).to eq(153.965442)
      expect(metadata.bit_rate).to eq(418650)
      expect(metadata.codec_name).to eq("flac")
      expect(metadata.sample_rate).to eq(44100)
      expect(metadata.channels).to eq(1)
      expect(metadata.bit_depth).to eq(16)
      expect(metadata.format).to eq("flac")
      expect(metadata.organization).to be_nil
      expect(metadata.replaygain_track_gain).to eq("-0.60 dB")
      expect(metadata.replaygain_track_peak).to eq("0.59744300")
      expect(metadata.lyrics).to be_nil
    end

    it "returns correct metadata for De Angelis mp3" do
      file = File.open(file_fixture("audio/raw/19500922__alfredo_de_angelis__nunca_te_podre_olvidar__carlos_dante__tango__TC3674_FREE.mp3"))
      metadata = AudioProcessing::MetadataExtractor.new.extract(file:)

      expect(metadata.title).to eq("Nunca te podré olvidar")
      expect(metadata.artist).to eq("Carlos Dante")
      expect(metadata.album).to eq("De Angelis - Su Obra Completa")
      expect(metadata.year).to eq("1950")
      expect(metadata.genre).to eq("Tango")
      expect(metadata.album_artist).to eq("Alfredo De Angelis")
      expect(metadata.album_artist_sort).to eq("De Angelis, Alfredo")
      expect(metadata.composer).to eq("Víctor Braña")
      expect(metadata.grouping).to eq("Free")
      expect(metadata.catalog_number).to eq("TC3674")
      expect(metadata.lyricist).to eq("Enrique Gaudino")
      expect(metadata.barcode).to eq("ERT-9479")
      expect(metadata.date).to eq("1950-09-22")
      expect(metadata.duration).to eq(184.11102)
      expect(metadata.bit_rate).to eq(324197)
      expect(metadata.codec_name).to eq("mp3")
      expect(metadata.sample_rate).to eq(44100)
      expect(metadata.channels).to eq(2)
      expect(metadata.bit_depth).to eq(0)
      expect(metadata.format).to eq("mp3")
      expect(metadata.organization).to be_nil
      expect(metadata.replaygain_track_gain).to eq("-1.90 dB")
      expect(metadata.replaygain_track_peak).to eq("0.936371")
      expect(metadata.lyrics).to be_present
    end
    it "returns correct metadata for normal flac" do
      file = File.open(file_fixture("audio/raw/19530101__anibal_troilo__vuelve_la_serenata__jorge_casal_y_raul_beron__vals__TC7514_FREE.flac"))
      metadata = AudioProcessing::MetadataExtractor.new.extract(file:)

      expect(metadata.title).to eq("Vuelve la serenata")
      expect(metadata.artist).to eq("Jorge Casal, Raúl Berón")
      expect(metadata.album).to eq("Troilo - Su Obra Completa (Soulseek)")
      expect(metadata.year).to eq("1953")
      expect(metadata.genre).to eq("Vals")
      expect(metadata.album_artist).to eq("Aníbal Troilo")
      expect(metadata.album_artist_sort).to eq("Troilo, Aníbal")
      expect(metadata.composer).to eq("Aníbal Troilo")
      expect(metadata.grouping).to eq("Free")
      expect(metadata.catalog_number).to eq("TC7514")
      expect(metadata.lyricist).to eq("Cátulo Castillo")
      expect(metadata.barcode).to eq("ERT-2918")
      expect(metadata.date).to eq("1953-01-01")
      expect(metadata.duration).to eq(154.546667)
      expect(metadata.bit_rate).to eq(558088)
      expect(metadata.codec_name).to eq("flac")
      expect(metadata.sample_rate).to eq(44100)
      expect(metadata.channels).to eq(2)
      expect(metadata.bit_depth).to eq(16)
      expect(metadata.format).to eq("flac")
      expect(metadata.organization).to eq("Tk")
      expect(metadata.replaygain_track_gain).to eq("-6.40 dB")
      expect(metadata.replaygain_track_peak).to eq("0.99453700")
      expect(metadata.lyrics).to be_present
    end

    it "returns correct metadata for director mp3" do
      file = File.open(file_fixture("audio/raw/19550101__alberto_moran__ciego__armando_cupo__tango__TC5905_FREE.mp3"))
      metadata = AudioProcessing::MetadataExtractor.new.extract(file:)

      expect(metadata.title).to eq("Ciego")
      expect(metadata.artist).to eq("Dir. Armando Cupo")
      expect(metadata.album).to eq("Moran - Su Obra Completa")
      expect(metadata.year).to eq("1955")
      expect(metadata.genre).to eq("Tango")
      expect(metadata.album_artist).to eq("Alberto Moran")
      expect(metadata.album_artist_sort).to eq("Morán, Alberto")
      expect(metadata.composer).to eq("Luis Rubistein")
      expect(metadata.grouping).to eq("Free")
      expect(metadata.catalog_number).to eq("TC5905")
      expect(metadata.lyricist).to eq("Luis Rubistein")
      expect(metadata.barcode).to eq("ERT-13804")
      expect(metadata.date).to eq("1955-01-01")
      expect(metadata.duration).to eq(185.39102)
      expect(metadata.bit_rate).to eq(326530)
      expect(metadata.codec_name).to eq("mp3")
      expect(metadata.sample_rate).to eq(44100)
      expect(metadata.channels).to eq(2)
      expect(metadata.bit_depth).to eq(0)
      expect(metadata.format).to eq("mp3")
      expect(metadata.organization).to be_nil
      expect(metadata.replaygain_track_gain).to eq("-1.10 dB")
      expect(metadata.replaygain_track_peak).to eq("0.854645")
      expect(metadata.lyrics).to be_present
    end
  end
end
