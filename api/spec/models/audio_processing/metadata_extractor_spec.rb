require "rails_helper"

RSpec.describe AudioProcessing::MetadataExtractor do
  describe "#extract_metadata" do
    it "returns a hash of metadata for aif" do
      file = File.open(Rails.root.join("spec/fixtures/audio/19380307_comme_il_faut_instrumental_tango_2758.aif"))
      metadata = AudioProcessing::MetadataExtractor.new(file).extract_metadata

      expect(metadata.title).to eq("comme il faut")
      expect(metadata.artist).to eq("instrumental")
      expect(metadata.album).to eq("tt - todo de anibal, 1938-1942 [aiff]")
      expect(metadata.date).to eq("1938-03-07")
      expect(metadata.track).to be_nil
      expect(metadata.genre).to eq("tango")
      expect(metadata.album_artist).to eq("anibal troilo")
      expect(metadata.catalog_number).to be_nil
      expect(metadata.composer).to eq("eduardo arolas")
      expect(metadata.performer).to be_nil
      expect(metadata.encoded_by).to be_nil
      expect(metadata.encoder).to eq("Lavf60.16.100")
      expect(metadata.media_type).to be_nil
      expect(metadata.date).to eq("1938-03-07")
      expect(metadata.genre).to eq("tango")
      expect(metadata.album_artist).to eq("anibal troilo")
      expect(metadata.catalog_number).to be_nil
      expect(metadata.composer).to eq("eduardo arolas")
      expect(metadata.performer).to be_nil
      expect(metadata.encoded_by).to be_nil
      expect(metadata.media_type).to be_nil
      expect(metadata.lyrics).to eq("Luna, farol y canción,\ndulce emoción del ayer\nfue en París,\ndonde viví tu amor.\nTango, Champagne, corazón,\nnoche de amor\nque no está,\nen mi sueño vivirá...\n\nEs como debe ser, con ilusión viví\nlas alegrías y las tristezas;\nen esa noche fue que yo sentí por vos\nuna esperanza en mi corazón.\nEs como debe ser en la pasión de ley,\ntus ojos negros y tu belleza.\nSiempre serás mi amor en bello amanecer\npara mi vida, dulce ilusión.\n\nEn este tango\nte cuento mi tristeza,\ndolor y llanto\nque dejo en esta pieza.\nQuiero que oigas mi canción\nhecha de luna y de farol\ny que tu amor, mujer,\nvuelva hacia mí.")
      expect(metadata.duration).to eq(163.879002)
      expect(metadata.bit_rate).to eq(708991)
      expect(metadata.codec_name).to eq("pcm_s16be")
      expect(metadata.codec_long_name).to eq("PCM signed 16-bit big-endian")
      expect(metadata.sample_rate).to eq(44100)
      expect(metadata.channels).to eq(1)
      expect(metadata.bit_depth).to eq(0)
      expect(metadata.bit_rate_mode).to be_nil
      expect(metadata.format).to eq("aiff")
      expect(metadata.comments).to eq("id: ert-2758 | source: tt | label: odeon | date: 1938-03-07 | original_album: 9326 - 7160 a tangotunes\r\n")
      expect(metadata.encoder).to eq("Lavf60.16.100")
      expect(metadata.bpm).to be_nil
      expect(metadata.ert_number).to eq(2758)
      expect(metadata.source).to eq("TangoTunes")
      expect(metadata.record_label).to eq("odeon")
      expect(metadata.lyricist).to eq("gabriel clausi")
      expect(metadata.original_album).to eq("9326 - 7160 a tangotunes")
    end

    it "returns a hash of metadata for flac" do
      file = File.open(Rails.root.join("spec/fixtures/audio/19401008_volver_a_sonar_roberto_rufino_tango_2476.flac"))
      metadata = AudioProcessing::MetadataExtractor.new(file).extract_metadata

      expect(metadata.title).to eq("volver a sonar")
      expect(metadata.artist).to eq("roberto rufino")
      expect(metadata.album).to eq("tt - todo de carlos -1939-1941 [flac]")
      expect(metadata.date).to eq("1940-10-08")
      expect(metadata.track).to be_nil
      expect(metadata.genre).to eq("tango")
      expect(metadata.album_artist).to eq("carlos di sarli")
      expect(metadata.catalog_number).to be_nil
      expect(metadata.composer).to eq("andres fraga")
      expect(metadata.performer).to be_nil
      expect(metadata.encoded_by).to be_nil
      expect(metadata.encoder).to eq("Lavf60.16.100")
      expect(metadata.media_type).to be_nil
      expect(metadata.lyrics).to eq("No sé si fue mi mano\nO fue la tuya\nQue escribió,\nLa carta del adiós\nEn nuestro amor.\n \nNo quiero ni saber\nQuién fue culpable\nDe los dos,\nNi pido desazones\nNi rencor.\n \nMe queda del ayer\nEnvuelto en tu querer,\nEl rastro de un perfume antiguo.\nMe queda de tu amor\nEl lánguido sabor\nDe un néctar\nQue ya nunca beberé.\n \nPor eso que esta estrofa\nAl muerto idilio, no es capaz,\nDe hacerlo entre los dos resucitar.\nSi acaso algo pretendo\nEs por ofrenda al corazón,\nSalvarlo del olvido, nada más...")
      expect(metadata.duration).to eq(165.158396)
      expect(metadata.bit_rate).to eq(1324082)
      expect(metadata.codec_name).to eq("flac")
      expect(metadata.codec_long_name).to eq("FLAC (Free Lossless Audio Codec)")
      expect(metadata.sample_rate).to eq(96000)
      expect(metadata.channels).to eq(1)
      expect(metadata.bit_depth).to eq(24)
      expect(metadata.bit_rate_mode).to be_nil
      expect(metadata.format).to eq("flac")
      expect(metadata.comments).to eq("id: ert-2476 | source: tt | label: rca victor | date: 1940-10-08 | original_album: bave 39533 - 39110 b tangotunes\r\n")
      expect(metadata.bpm).to eq("130.78")
      expect(metadata.encoder).to eq("Lavf60.16.100")
      expect(metadata.bpm).to eq("130.78")
      expect(metadata.ert_number).to eq(2476)
      expect(metadata.source).to eq("TangoTunes")
      expect(metadata.record_label).to eq("rca victor")
      expect(metadata.singer).to eq("roberto rufino")
      expect(metadata.lyricist).to eq("francisco garcia jimenez")
      expect(metadata.original_album).to eq("bave 39533 - 39110 b tangotunes")
    end
  end
end
