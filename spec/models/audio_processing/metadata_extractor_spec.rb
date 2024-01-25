# frozen_string_literal: true

require "rails_helper"

RSpec.describe AudioProcessing::MetadataExtractor do
  describe "#extract_metadata" do
    it "returns a hash of metadata for aif" do
      file = Rails.root.join("spec/fixtures/029_-_Nunca_tuvo_novio.aif")
      metadata = AudioProcessing::MetadataExtractor.new(file:).extract_metadata

      expect(metadata.title).to eq("Nunca tuvo novio")
      expect(metadata.artist).to eq("Pedro Laurenz / Alberto Podestá")
      expect(metadata.album).to eq("Todos de Pedro Laurenz 1937-1968, Tango Time Travel 5")
      expect(metadata.date).to eq("1943-04-16")
      expect(metadata.track).to eq("029")
      expect(metadata.genre).to eq("Tango")
      expect(metadata.album_artist).to eq("Pedro Laurenz")
      expect(metadata.catalog_number).to eq("Record: 60-0063-A, Matrix: 84311, Take : 1")
      expect(metadata.composer).to eq("A. Bardi, E. Cadícamo")
      expect(metadata.performer).to eq("Pedro Laurenz")
      expect(metadata.encoded_by).to eq("© 2021 TangoTimeTravel.org, 78-rpm shellac collection of first fixations")
      expect(metadata.media_type).to eq("TT/78")
      expect(metadata.lyrics).to eq("Pobre solterona te has quedado\nsin ilusión, sin fe...\nTu corazón de angustias se ha enfermado,\npuesta de sol es hoy tu vida trunca.\nSigues como entonces, releyendo\nel novelón sentimental,\nen el que una niña aguarda en vano\nconsumida por un mal de amor.\n\nEn la soledad\nde tu pieza de soltera está el dolor.\nTriste realidad\nes el fin de tu jornada sin amor...\nLloras y al llorar\nvan las lágrimas temblando tu emoción;\nen las hojas de tu viejo novelón\nte ves sin fuerza palpitar.\nDeja de llorar\npor el príncipe soñado que no fue\njunto a ti a volcar\nel rimero melodioso de su voz.\nTras el ventanal,\nmientras pega la llovizna en el cristal\ncon tus ojos más nublados de dolor\nsoñás un paisaje de amor.\n\nNunca tuvo novio, ¡pobrecita!\n¿Por qué el amor no fue\na su jardin humilde de muchacha\na reanimar las flores de sus años?.\n¡Yo, con mi montón de desengaños\nigual que vos, vivo sin luz,\nsin una caricia venturosa\nque haga olvidar mi cruz!")
      expect(metadata.duration).to eq(199.272698)
      expect(metadata.bit_rate).to eq(783426)
      expect(metadata.codec_name).to eq("pcm_s16be")
      expect(metadata.codec_long_name).to eq("PCM signed 16-bit big-endian")
      expect(metadata.sample_rate).to eq(44100)
      expect(metadata.channels).to eq(1)
      expect(metadata.bit_depth).to eq(0)
      expect(metadata.bit_rate_mode).to be_nil
      expect(metadata.format).to eq("aiff")
      expect(metadata.comment).to be_nil
      expect(metadata.encoder).to be_nil
    end

    it "returns a hash of metadata for flac" do
      file = Rails.root.join("spec/fixtures/Amarras 79782-1_RP.flac")
      metadata = AudioProcessing::MetadataExtractor.new(file:).extract_metadata

      expect(metadata.title).to eq("Amarras")
      expect(metadata.artist).to eq("Héctor Mauré")
      expect(metadata.album).to eq("BAVE 79782-1 - 60-0497 A TangoTunes")
      expect(metadata.date).to eq("1944")
      expect(metadata.track).to be_nil
      expect(metadata.genre).to eq("Tango")
      expect(metadata.album_artist).to eq("Juan D’Arienzo")
      expect(metadata.catalog_number).to be_nil
      expect(metadata.composer).to eq("Aut: Carmelo Santiago, Com: Carlos Marchisio")
      expect(metadata.performer).to be_nil
      expect(metadata.encoded_by).to be_nil
      expect(metadata.encoder).to eq("X Lossless Decoder 20191004")
      expect(metadata.media_type).to be_nil
      expect(metadata.lyrics).to be_nil
      expect(metadata.duration).to eq(211.196854)
      expect(metadata.bit_rate).to eq(1208597)
      expect(metadata.codec_name).to eq("flac")
      expect(metadata.codec_long_name).to eq("FLAC (Free Lossless Audio Codec)")
      expect(metadata.sample_rate).to eq(96000)
      expect(metadata.channels).to eq(1)
      expect(metadata.bit_depth).to eq(24)
      expect(metadata.bit_rate_mode).to be_nil
      expect(metadata.format).to eq("flac")
      expect(metadata.comment).to eq("1944-07-21")
    end
  end
end
