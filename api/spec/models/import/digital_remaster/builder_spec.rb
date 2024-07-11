require "rails_helper"

RSpec.describe Import::DigitalRemaster::Builder do
  let(:audio_file) { create(:flac_audio_file) }
  let(:metadata) do
    AudioProcessing::MetadataExtractor::Metadata.new(
      duration: 165.158396,
      bit_rate: 1325044,
      bit_depth: 24,
      codec_name: "flac",
      codec_long_name: "FLAC (Free Lossless Audio Codec)",
      sample_rate: 96000,
      channels: 1,
      title: "Volver a soñar",
      artist: "Roberto Rufino",
      album: "TT - Todo de Carlos -1939-1941 [FLAC]",
      date: "1940-10-08",
      genre: "Tango",
      album_artist: "Carlos Di Sarli",
      composer: "Andrés Fraga",
      publisher: "Rca Victor",
      lyrics: "No sé si fue mi mano\r\nO fue la tuya\r\nQue escribió,\r\nLa carta del adiós\r\nEn nuestro amor.\r\n \r\nNo quiero ni saber\r\nQuién fue culpable\r\nDe los dos,\r\nNi pido desazones\r\nNi rencor.\r\n \r\nMe queda del ayer\r\nEnvuelto en tu querer,\r\nEl rastro de un perfume antiguo.\r\nMe queda de tu amor\r\nEl lánguido sabor\r\nDe un néctar\r\nQue ya nunca beberé.\r\n \r\nPor eso que esta estrofa\r\nAl muerto idilio, no es capaz,\r\nDe hacerlo entre los dos resucitar.\r\nSi acaso algo pretendo\r\nEs por ofrenda al corazón,\r\nSalvarlo del olvido, nada más...",
      format: "flac",
      ert_number: 2476,
      source: "TangoTunes",
      lyricist: "Francisco García Jiménez",
      album_artist_sort: "Di Sarli, Carlos",
      catalog_number: "TC2476",
      grouping: "Tango Tunes",
      replay_gain: -7.0
    )
  end

  describe "#build_audio_variant" do
    it "builds a new audio variant" do
      audio_variant = Import::DigitalRemaster::Builder.new.build_audio_variant(metadata:)
      expect(audio_variant).to be_a_new(AudioVariant)
      expect(audio_variant.format).to eq("flac")
      expect(audio_variant.bit_rate).to eq(1325044)
    end
  end

  describe "#build_waveform" do
    it "builds a new waveform" do
      waveform = AudioProcessing::WaveformGenerator::Waveform.new(
        version: 1,
        channels: 1,
        sample_rate: 44100,
        samples_per_pixel: 1024,
        bits: 16,
        length: 100,
        data: [0.1, 0.2, 0.3, 0.4]
      )
      waveform = Import::DigitalRemaster::Builder.new.build_waveform(waveform:)
      expect(waveform).to be_a_new(Waveform)
      expect(waveform.version).to eq(1)
      expect(waveform.channels).to eq(1)
      expect(waveform.sample_rate).to eq(44100)
      expect(waveform.samples_per_pixel).to eq(1024)
      expect(waveform.bits).to eq(16)
      expect(waveform.length).to eq(100)
      expect(waveform.data).to eq([0.1, 0.2, 0.3, 0.4])
    end
  end

  describe "#build_recording" do
    it "build a new recording" do
      recording = Import::DigitalRemaster::Builder.new.build_recording(metadata:)
      expect(recording).to be_a_new(Recording)
      expect(recording.title).to eq("Volver a soñar")
      expect(recording.recorded_date).to eq("1940-10-08".to_date)
      expect(recording.recording_type).to eq("studio")
      expect(recording.orchestra.name).to eq("Carlos Di Sarli")
      expect(recording.genre.name).to eq("Tango")
      expect(recording.composition.title).to eq("Volver a soñar")
      expect(recording.composition.composers.first.name).to eq("Andrés Fraga")
      expect(recording.composition.lyricists.first.name).to eq("Francisco García Jiménez")
      expect(recording.singers.map(&:name)).to contain_exactly("Roberto Rufino")
      expect(recording.record_label.name).to eq("Rca Victor")
    end

    it "associates the recording with the correct time period" do
      create(:time_period, start_year: 1939, end_year: 1941, name: "Early 1940s")
      recording = Import::DigitalRemaster::Builder.new.build_recording(metadata:)
      expect(recording.time_period.name).to eq("Early 1940s")
    end

    it "does not associate a time period if none match" do
      create(:time_period, start_year: 1950, end_year: 1960, name: "1950s")
      recording = Import::DigitalRemaster::Builder.new.build_recording(metadata:)
      expect(recording.time_period).to be_nil
    end
  end

  describe "#find_or_initialize_album" do
    it "creates a new album if it doesn't exist" do
      album = Import::DigitalRemaster::Builder.new.find_or_initialize_album(metadata:)
      expect(album).to be_a_new(Album)
      expect(album.title).to eq("TT - Todo de Carlos -1939-1941 [FLAC]")
      expect(album.description).to be_nil
    end

    it "finds an existing album if it exists" do
      create(:album, title: "TT - Todo de Carlos -1939-1941 [FLAC]")
      album = Import::DigitalRemaster::Builder.new.find_or_initialize_album(metadata:)
      expect(album).not_to be_a_new(Album)
    end
  end

  describe "#find_or_initialize_remaster_agent" do
    it "creates a new remaster agent if it doesn't exist" do
      remaster_agent = Import::DigitalRemaster::Builder.new.find_or_initialize_remaster_agent(metadata:)
      expect(remaster_agent).to be_a_new(RemasterAgent)
      expect(remaster_agent.name).to eq("Tango Tunes")
    end

    it "finds an existing remaster agent if it exists" do
      existing_remaster_agent = create(:remaster_agent, name: "TangoTunes")
      remaster_agent = Import::DigitalRemaster::Builder.new.find_or_initialize_remaster_agent(metadata:)

      expect(remaster_agent).not_to be_a_new(RemasterAgent)
      expect(remaster_agent).to eq(existing_remaster_agent)
    end
  end

  describe "#find_or_initialize_orchestra" do
    it "creates a new orchestra if it doesn't exist" do
      orchestra = Import::DigitalRemaster::Builder.new.find_or_initialize_orchestra(metadata:)
      expect(orchestra).to be_a_new(Orchestra)
      expect(orchestra.name).to eq("Carlos Di Sarli")
      expect(orchestra.sort_name).to eq("Di Sarli, Carlos")
    end

    it "finds an existing orchestra if it exists" do
      create(:orchestra, name: "Carlos Di Sarli")
      orchestra = Import::DigitalRemaster::Builder.new.find_or_initialize_orchestra(metadata:)
      expect(orchestra).not_to be_a_new(Orchestra)
    end
  end

  describe "#find_or_initialize_singers" do
    it "creates new singers if they don't exist" do
      singers = Import::DigitalRemaster::Builder.new.find_or_initialize_singers(metadata:)
      expect(singers.map(&:name)).to contain_exactly("Roberto Rufino")
      expect(singers.all?(&:new_record?)).to be true
    end

    it "finds existing singers if they exist" do
      create(:person, name: "Roberto Rufino")
      singers = Import::DigitalRemaster::Builder.new.find_or_initialize_singers(metadata:)
      expect(singers.map(&:name)).to contain_exactly("Roberto Rufino")
      expect(singers.all?(&:persisted?)).to be true
    end

    it "ignores 'Instrumental' artist" do
      metadata_with_instrumental = OpenStruct.new(artist: "Instrumental")

      singers = Import::DigitalRemaster::Builder.new.find_or_initialize_singers(metadata: metadata_with_instrumental)
      expect(singers).to be_empty
    end

    it "processes 'Dir. XXXXXX' as soloist" do
      metadata_with_instrumental = OpenStruct.new(artist: "Dir. Carlos Di Sarli")
      singers = Import::DigitalRemaster::Builder.new.find_or_initialize_singers(metadata: metadata_with_instrumental)
      expect(singers.map(&:name)).to contain_exactly("Carlos Di Sarli")
      expect(singers.first).to be_a(Person)
      expect(singers.first.recording_singers.first.soloist).to be true
    end
  end

  describe "#find_or_initialize_genre" do
    it "creates a new genre if it doesn't exist" do
      genre = Import::DigitalRemaster::Builder.new.find_or_initialize_genre(metadata:)
      expect(genre).to be_a_new(Genre)
      expect(genre.name).to eq("Tango")
    end

    it "finds an existing genre if it exists" do
      create(:genre, name: "Tango")
      genre = Import::DigitalRemaster::Builder.new.find_or_initialize_genre(metadata:)
      expect(genre).not_to be_a_new(Genre)
    end
  end

  describe "#find_or_initialize_composer" do
    it "creates a new composer if it doesn’t exist" do
      composer = Import::DigitalRemaster::Builder.new.find_or_initialize_composer(metadata:)
      expect(composer).to be_a_new(Person)
      expect(composer.name).to eq("Andrés Fraga")
      expect(composer.birth_date).to be_nil
      expect(composer.death_date).to be_nil
    end
    it "finds an existing composer if it exists" do
      create(:person, name: "Andrés Fraga")
      composer = Import::DigitalRemaster::Builder.new.find_or_initialize_composer(metadata:)
      expect(composer).not_to be_a_new(Person)
    end
  end

  describe "#find_or_initialize_lyricist" do
    it "creates a new lyricist if it doesn't exist" do
      lyricist = Import::DigitalRemaster::Builder.new.find_or_initialize_lyricist(metadata:)
      expect(lyricist).to be_a_new(Person)
      expect(lyricist.name).to eq("Francisco García Jiménez")
      expect(lyricist.birth_date).to be_nil
      expect(lyricist.death_date).to be_nil
    end

    it "finds an existing lyricist if it exists" do
      create(:person, name: "Francisco García Jiménez")
      lyricist = Import::DigitalRemaster::Builder.new.find_or_initialize_lyricist(metadata:)
      expect(lyricist).not_to be_a_new(Person)
    end
  end

  describe "#find_or_initialize_composition" do
    it "creates a new composition if it doesn't exist" do
      composition = Import::DigitalRemaster::Builder.new.find_or_initialize_composition(metadata:)
      expect(composition).to be_a_new(Composition)
      expect(composition.title).to eq("Volver a soñar")
      expect(composition.composers.first.name).to eq("Andrés Fraga")
      expect(composition.lyricists.first.name).to eq("Francisco García Jiménez")
    end

    it "finds an existing composition if it exists" do
      create(:composition, title: "Volver a soñar")
      composition = Import::DigitalRemaster::Builder.new.find_or_initialize_composition(metadata:)
      expect(composition).not_to be_a_new(Composition)
    end
  end

  describe "#find_or_initialize_lyrics" do
    it "creates a new lyrics if it doesn't exist" do
      composition = create(:composition, title: "Volver a soñar")
      Import::DigitalRemaster::Builder.new.find_or_initialize_lyrics(metadata:, composition:)
      expect(composition.lyrics).to be_present
    end
  end

  describe "#find_existing_time_period" do
    it "returns nil if date is blank" do
      time_period = Import::DigitalRemaster::Builder.new.find_existing_time_period(metadata: OpenStruct.new(date: nil))
      expect(time_period).to be_nil
    end

    it "returns nil if no time period covers the year" do
      create(:time_period, start_year: 1950, end_year: 1960, name: "1950s")
      time_period = Import::DigitalRemaster::Builder.new.find_existing_time_period(metadata: OpenStruct.new(date: "1940-10-08"))
      expect(time_period).to be_nil
    end

    it "returns a time period if it exists" do
      existing_time_period = create(:time_period, start_year: 1939, end_year: 1941)
      metadata = OpenStruct.new(date: "1940-10-08")
      time_period = Import::DigitalRemaster::Builder.new.find_existing_time_period(metadata:)
      expect(time_period).to eq(existing_time_period)
    end
  end

  describe "#find_or_intialize_record_label" do
    it "creates a new record label if it doesn't exist" do
      record_label = Import::DigitalRemaster::Builder.new.find_or_initialize_record_label(metadata:)
      expect(record_label).to be_a_new(RecordLabel)
      expect(record_label.name).to eq("Rca Victor")
    end

    it "finds an existing record label if it exists" do
      create(:record_label, name: "Rca Victor")
      record_label = Import::DigitalRemaster::Builder.new.find_or_initialize_record_label(metadata:)
      expect(record_label).not_to be_a_new(RecordLabel)
    end
  end

  describe "#build_digital_remaster" do
    it "builds a new digital remaster" do
      album_art = File.open(Rails.root.join("spec/support/assets/album_art.jpg"))
      waveform = AudioProcessing::WaveformGenerator::Waveform.new(
        version: 1,
        channels: 1,
        sample_rate: 44100,
        samples_per_pixel: 1024,
        bits: 16,
        length: 100,
        data: [0.1, 0.2, 0.3, 0.4]
      )
      waveform_image = File.open(Rails.root.join("spec/support/assets/19401008_volver_a_sonar_roberto_rufino_tango_2476.mp3"))
      compressed_audio = File.open(Rails.root.join("spec/fixtures/files/audio/compressed/19401008_volver_a_sonar_roberto_rufino_tango_2476.mp3"))
      digital_remaster = Import::DigitalRemaster::Builder.new.build_digital_remaster(audio_file:, metadata:, waveform:, waveform_image:, album_art:, compressed_audio:)
      expect(digital_remaster).to be_a_new(DigitalRemaster)
      expect(digital_remaster.duration).to eq(165)
      expect(digital_remaster.bpm).to be_nil
      expect(digital_remaster.external_id).to be_nil
      expect(digital_remaster.replay_gain).to eq(-7.0)
      expect(digital_remaster.tango_cloud_id).to eq(2476)
      expect(digital_remaster.album).to be_a(Album)
      expect(digital_remaster.remaster_agent).to be_a(RemasterAgent)
      expect(digital_remaster.recording).to be_a(Recording)
      expect(digital_remaster.audio_file).to be_a(AudioFile)
      expect(digital_remaster.waveform).to be_a(Waveform)
      expect(digital_remaster.audio_variants).to contain_exactly(an_instance_of(AudioVariant))
      expect(digital_remaster.album.album_art).to be_attached
      expect(digital_remaster.audio_file.file).to be_attached
      expect(digital_remaster.waveform.image).to be_attached
      expect(digital_remaster.recording.singers.map(&:name)).to contain_exactly("Roberto Rufino")
      expect(digital_remaster.recording.composition.title).to eq("Volver a soñar")
      expect(digital_remaster.recording.composition.composers.first.name).to eq("Andrés Fraga")
      expect(digital_remaster.recording.composition.lyricists.first.name).to eq("Francisco García Jiménez")
      expect(digital_remaster.recording.orchestra.name).to eq("Carlos Di Sarli")
      expect(digital_remaster.recording.genre.name).to eq("Tango")
      expect(digital_remaster.album.title).to eq("TT - Todo de Carlos -1939-1941 [FLAC]")
      expect(digital_remaster.remaster_agent.name).to eq("TangoTunes")
      expect(digital_remaster.recording.recorded_date).to eq("1940-10-08".to_date)
      expect(digital_remaster.recording.record_label.name).to eq("Rca Victor")
    end
  end
end
