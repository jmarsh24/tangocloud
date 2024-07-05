require "rails_helper"

RSpec.describe Import::AudioTransfer::Builder do
  let(:audio_file) { create(:flac_audio_file) }
  let(:metadata) do
    OpenStruct.new(
      duration: 165.158396,
      bit_rate: 1325044,
      bit_depth: 24,
      codec_name: "flac",
      codec_long_name: "FLAC (Free Lossless Audio Codec)",
      sample_rate: 96000,
      channels: 1,
      title: "Volver a soñar",
      artist: ["Roberto Rufino"],
      album: "TT - Todo de Carlos -1939-1941 [FLAC]",
      date: "1940-10-08",
      genre: "Tango",
      album_artist: "Carlos Di Sarli",
      composer: "Andrés Fraga",
      record_label: "Rca Victor",
      lyrics: "No sé si fue mi mano\r\nO fue la tuya\r\nQue escribió,\r\nLa carta del adiós\r\nEn nuestro amor.\r\n \r\nNo quiero ni saber\r\nQuién fue culpable\r\nDe los dos,\r\nNi pido desazones\r\nNi rencor.\r\n \r\nMe queda del ayer\r\nEnvuelto en tu querer,\r\nEl rastro de un perfume antiguo.\r\nMe queda de tu amor\r\nEl lánguido sabor\r\nDe un néctar\r\nQue ya nunca beberé.\r\n \r\nPor eso que esta estrofa\r\nAl muerto idilio, no es capaz,\r\nDe hacerlo entre los dos resucitar.\r\nSi acaso algo pretendo\r\nEs por ofrenda al corazón,\r\nSalvarlo del olvido, nada más...",
      format: "flac",
      ert_number: 2476,
      source: "TangoTunes",
      lyricist: "Francisco García Jiménez",
      artist_sort: "Di Sarli, Carlos"
    )
  end

  describe "#find_or_initialize_album" do
    it "creates a new album if it doesn't exist" do
      album = Import::AudioTransfer::Builder.new.find_or_initialize_album(metadata:)
      expect(album).to be_a_new(Album)
      expect(album.title).to eq("TT - Todo de Carlos -1939-1941 [FLAC]")
      expect(album.description).to be_nil
      expect(album.album_type).to eq("compilation")
    end

    it "finds an existing album if it exists" do
      create(:album, title: "TT - Todo de Carlos -1939-1941 [FLAC]")
      album = Import::AudioTransfer::Builder.new.find_or_initialize_album(metadata:)
      expect(album).not_to be_a_new(Album)
    end
  end

  describe "#find_or_initialize_transfer_agent" do
    it "creates a new transfer agent if it doesn't exist" do
      transfer_agent = Import::AudioTransfer::Builder.new.find_or_initialize_transfer_agent(metadata:)
      expect(transfer_agent).to be_a_new(TransferAgent)
      expect(transfer_agent.name).to eq("TangoTunes")
    end

    it "finds an existing transfer agent if it exists" do
      existing_transfer_agent = create(:transfer_agent, name: "TangoTunes")
      transfer_agent = Import::AudioTransfer::Builder.new.find_or_initialize_transfer_agent(metadata:)

      expect(transfer_agent).not_to be_a_new(TransferAgent)
      expect(transfer_agent).to eq(existing_transfer_agent)
    end
  end

  describe "#find_or_initialize_recording" do
    it "creates a new recording if it doesn't exist" do
      recording = Import::AudioTransfer::Builder.new.find_or_initialize_recording(metadata:)
      expect(recording).to be_a_new(Recording)
      expect(recording.title).to eq("Volver a soñar")
      expect(recording.recorded_date).to eq("1940-10-08".to_date)
      expect(recording.recording_type).to eq("studio")
      expect(recording.orchestra.name).to eq("Carlos Di Sarli")
      expect(recording.genre.name).to eq("Tango")
      expect(recording.composition.title).to eq("Volver a soñar")
      expect(recording.composition.composer.name).to eq("Andrés Fraga")
      expect(recording.composition.lyricist.name).to eq("Francisco García Jiménez")
      expect(recording.singers.map(&:name)).to contain_exactly("Roberto Rufino")
    end

    it "finds an existing recording if it exists" do
      create(:recording, title: "Volver a soñar")
      recording = Import::AudioTransfer::Builder.new.find_or_initialize_recording(metadata:)
      expect(recording).not_to be_a_new(Recording)
    end
  end

  describe "#find_or_initialize_orchestra" do
    it "creates a new orchestra if it doesn't exist" do
      orchestra = Import::AudioTransfer::Builder.new.find_or_initialize_orchestra(metadata:)
      expect(orchestra).to be_a_new(Orchestra)
      expect(orchestra.name).to eq("Carlos Di Sarli")
      expect(orchestra.sort_name).eq("Di Sarli, Carlos")
      expect(orchestra.birth_date).to be_nil
      expect(orchestra.death_date).to be_nil
    end

    it "finds an existing orchestra if it exists" do
      create(:orchestra, name: "Carlos Di Sarli")
      orchestra = Import::AudioTransfer::Builder.new.find_or_initialize_orchestra(metadata:)
      expect(orchestra).not_to be_a_new(Orchestra)
    end
  end

  describe "#find_or_initialize_singers" do
    it "creates new singers if they don't exist" do
      singers = Import::AudioTransfer::Builder.new.find_or_initialize_singers(metadata:)
      expect(singers.map(&:name)).to contain_exactly("Roberto Rufino")
      expect(singers.all?(&:new_record?)).to be true
    end

    it "finds existing singers if they exist" do
      create(:singer, name: "Roberto Rufino")
      singers = Import::AudioTransfer::Builder.new.find_or_initialize_singers(metadata:)
      expect(singers.map(&:name)).to contain_exactly("Roberto Rufino")
      expect(singers.all?(&:persisted?)).to be true
    end
  end

  describe "#find_or_initialize_genre" do
    it "creates a new genre if it doesn't exist" do
      genre = Import::AudioTransfer::Builder.new.find_or_initialize_genre(metadata:)
      expect(genre).to be_a_new(Genre)
      expect(genre.name).to eq("Tango")
      expect(genre.description).to be_nil
    end

    it "finds an existing genre if it exists" do
      create(:genre, name: "Tango")
      genre = Import::AudioTransfer::Builder.new.find_or_initialize_genre(metadata:)
      expect(genre).not_to be_a_new(Genre)
    end
  end

  describe "#find_or_initialize_composer" do
    it "creates a new composer if it doesn't exist" do
      composer = Import::AudioTransfer::Builder.new.find_or_initialize_composer(metadata:)
      expect(composer).to be_a_new(Composer)
      expect(composer.name).to eq("Andrés Fraga")
      expect(composer.birth_date).to be_nil
      expect(composer.death_date).to be_nil
    end

    it "finds an existing composer if it exists" do
      create(:composer, name: "Andrés Fraga")
      composer = Import::AudioTransfer::Builder.new.find_or_initialize_composer(metadata:)
      expect(composer).not_to be_a_new(Composer)
    end
  end

  describe "#find_or_initialize_lyricist" do
    it "creates a new lyricist if it doesn't exist" do
      lyricist = Import::AudioTransfer::Builder.new.find_or_initialize_lyricist(metadata:)
      expect(lyricist).to be_a_new(Lyricist)
      expect(lyricist.name).to eq("Francisco García Jiménez")
      expect(lyricist.birth_date).to be_nil
      expect(lyricist.death_date).to be_nil
    end

    it "finds an existing lyricist if it exists" do
      create(:lyricist, name: "Francisco García Jiménez")
      lyricist = Import::AudioTransfer::Builder.new.find_or_initialize_lyricist(metadata:)
      expect(lyricist).not_to be_a_new(Lyricist)
    end
  end

  describe "#find_or_initialize_composition" do
    it "creates a new composition if it doesn't exist" do
      composition = Import::AudioTransfer::Builder.new.find_or_initialize_composition(metadata:)
      expect(composition).to be_a_new(Composition)
      expect(composition.title).to eq("Volver a soñar")
      expect(composition.composer.name).to eq("Andrés Fraga")
      expect(composition.lyricist.name).to eq("Francisco García Jiménez")
    end

    it "finds an existing composition if it exists" do
      create(:composition, title: "Volver a soñar")
      composition = Import::AudioTransfer::Builder.new.find_or_initialize_composition(metadata:)
      expect(composition).not_to be_a_new(Composition)
    end
  end
end
