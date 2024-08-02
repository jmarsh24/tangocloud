require "rails_helper"

RSpec.describe Import::DigitalRemaster::Builder do
  let(:audio_file) { create(:flac_audio_file) }
  let(:metadata) do
    AudioProcessing::MetadataExtractor::Metadata.new(
      title: "Vuelve la serenata",
      artist: "Jorge Casal, Raúl Berón",
      album: "Troilo - Su Obra Completa (Soulseek)",
      year: "1953",
      genre: "Vals",
      album_artist: "Aníbal Troilo",
      album_artist_sort: "Troilo, Aníbal",
      composer: "Aníbal Troilo",
      grouping: "Free",
      catalog_number: "TC7514",
      lyricist: "Cátulo Castillo",
      barcode: "ERT-2918",
      date: "1953-01-01",
      duration: 154.546667,
      bit_rate: 558088,
      codec_name: "flac",
      sample_rate: 44100,
      channels: 2,
      bit_depth: 16,
      format: "flac",
      organization: "Tk",
      replaygain_track_gain: "-6.40 dB",
      replaygain_track_peak: "0.99453700",
      lyrics: "Yo te traigo de vuelta muchacha,\r\nla feliz serenta perdida;\r\ny en el vals que el ayer deshilacha,\r\nla luna borracha, camina dormida.\r\nA los dos el dolor nos amarra\r\ncon el mismo cansancio dulzón,\r\npalpitando en aquella guitarra,\r\nla dulce cigarra de tu corazón.\r\n\r\nHoy ha vuelto ya ves y a su modo,\r\nte despierta, cantando en sigilo;\r\nlas tristezas que doblan el codo,\r\nnos dicen que todo descansa tranquilo;\r\nasomate, no seas ingrata,\r\nque la serenata te llama al balcón.\r\n\r\nSerenata del barrio perdido,\r\ncon sus ecos de esquina lejana,\r\nhoy que sabes que todo está herido,\r\ntu mano ha corrido la vieja persiana.\r\nAsomate otra vez como entonces\r\ny encendele la luz del quinqué,\r\nporque quiere decir en sus voces,\r\nmuchacha no llores, no tienes porqué."
    )
  end

  describe "#build_audio_variant" do
    it "builds a new audio variant" do
      audio_variant = Import::DigitalRemaster::Builder.new.build_audio_variant(metadata:)
      expect(audio_variant).to be_a_new(AudioVariant)
      expect(audio_variant.format).to eq("flac")
      expect(audio_variant.bit_rate).to eq(558088)
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
    it "builds a new recording" do
      recording = Import::DigitalRemaster::Builder.new.build_recording(metadata:)
      expect(recording.title).to eq("Vuelve la serenata")
      expect(recording.recorded_date).to eq("1953-01-01".to_date)
      expect(recording.recording_type).to eq("studio")
      expect(recording.orchestra.name).to eq("Aníbal Troilo")
      expect(recording.genre.name).to eq("Vals")
      expect(recording.composition.title).to eq("Vuelve la serenata")
      expect(recording.composition.composition_roles.find { _1.role == "composer" }.person.name).to eq("Aníbal Troilo")
      expect(recording.composition.composition_roles.find { _1.role == "lyricist" }.person.name).to eq("Cátulo Castillo")
      expect(recording.recording_singers.map { _1.person.name }).to include("Jorge Casal", "Raúl Berón")
      expect(recording.record_label.name).to eq("Tk")
    end

    it "associates the recording with the correct time period" do
      create(:time_period, start_year: 1950, end_year: 1960, name: "1950s")
      recording = Import::DigitalRemaster::Builder.new.build_recording(metadata:)
      expect(recording.time_period.name).to eq("1950s")
    end

    it "does not associate a time period if none match" do
      create(:time_period, start_year: 1960, end_year: 1970, name: "1960s")
      recording = Import::DigitalRemaster::Builder.new.build_recording(metadata:)
      expect(recording.time_period).to be_nil
    end
  end

  describe "#find_or_initialize_album" do
    it "creates a new album if it doesn't exist" do
      album = Import::DigitalRemaster::Builder.new.find_or_initialize_album(metadata:)
      expect(album.title).to eq("Troilo - Su Obra Completa (Soulseek)")
      expect(album.description).to be_nil
    end

    it "finds an existing album if it exists" do
      create(:album, title: "Troilo - Su Obra Completa (Soulseek)")
      Import::DigitalRemaster::Builder.new.find_or_initialize_album(metadata:)
    end
  end

  describe "#find_or_initialize_remaster_agent" do
    it "creates a new remaster agent if it doesn't exist" do
      remaster_agent = Import::DigitalRemaster::Builder.new.find_or_initialize_remaster_agent(metadata:)
      expect(remaster_agent.name).to eq("Tk")
    end

    it "finds an existing remaster agent if it exists" do
      create(:remaster_agent, name: "Tk")
      remaster_agent = Import::DigitalRemaster::Builder.new.find_or_initialize_remaster_agent(metadata:)

      expect(remaster_agent.name).to eq("Tk")
    end
  end

  describe "#find_or_initialize_orchestra" do
    context "when el_recodo_song exists" do
      let(:person_role_data) do
        [
          {name: "Jorge Casal", role: "singer", birth_date: "1924-01-14", death_date: "1996-06-25", nicknames: [], real_name: "Pappalardo, Salvador Carmelo", place_of_birth: "Buenos Aires Argentina"},
          {name: "Carlos Figari", role: "piano", birth_date: "1913-08-03", death_date: "1994-10-22", nicknames: [], real_name: "Figari, Carlos Alberto", place_of_birth: "Buenos Aires Argentina"},
          {name: "Kicho Díaz", role: "doublebass", birth_date: "1918-01-21", death_date: "1992-10-05", nicknames: [], real_name: "Díaz, Enrique", place_of_birth: "Buenos Aires Argentina"},
          {name: "David Díaz", role: "violin", birth_date: "1906-05-17", death_date: "1977-05-08", nicknames: [], real_name: "Díaz, David José", place_of_birth: "Tandil (Buenos Aires) Argentina"},
          {name: "Alfredo Citro", role: "cello", birth_date: nil, death_date: nil, nicknames: [], real_name: nil, place_of_birth: nil}
        ]
      end

      let(:el_recodo_song) do
        song = ::ExternalCatalog::ElRecodo::Song.create!(
          ert_number: 2918,
          title: "Vuelve la serenata",
          date: "1953-01-01",
          style: "Vals",
          duration: 152,
          synced_at: Time.now,
          page_updated_at: "2013-07-03 18:18:00"
        )

        person_role_data.each do |person_data|
          person = ::ExternalCatalog::ElRecodo::Person.create!(
            name: person_data[:name],
            birth_date: person_data[:birth_date],
            death_date: person_data[:death_date],
            real_name: person_data[:real_name],
            place_of_birth: person_data[:place_of_birth],
            nicknames: person_data[:nicknames],
            synced_at: Time.now
          )
          ::ExternalCatalog::ElRecodo::PersonRole.create!(
            person:,
            song:,
            role: person_data[:role]
          )
        end
        song
      end

      it "creates a new orchestra if it doesn't exist" do
        orchestra = Import::DigitalRemaster::Builder.new.find_or_initialize_orchestra(metadata:)
        expect(orchestra.name).to eq("Aníbal Troilo")
        expect(orchestra.sort_name).to eq("Troilo, Aníbal")
      end

      it "finds an existing orchestra if it exists" do
        create(:orchestra, name: "Aníbal Troilo")
        Import::DigitalRemaster::Builder.new.find_or_initialize_orchestra(metadata:)
      end

      it "associates the orchestra with relevant roles" do
        orchestra = Import::DigitalRemaster::Builder.new.find_or_initialize_orchestra(metadata:, el_recodo_song:)

        expect(orchestra.orchestra_positions.map { _1.person.name }).to contain_exactly("Carlos Figari", "Kicho Díaz", "David Díaz", "Alfredo Citro")
        expect(orchestra.orchestra_positions.map { _1.orchestra_role.name }).to contain_exactly("Pianist", "Double Bassist", "Violinist", "Cellist")
        expect(orchestra.orchestra_positions.map { _1.person.birth_date }).to contain_exactly("1913-08-03".to_date, "1918-01-21".to_date, "1906-05-17".to_date, nil)
        expect(orchestra.orchestra_positions.map { _1.person.death_date }).to contain_exactly("1994-10-22".to_date, "1992-10-05".to_date, "1977-05-08".to_date, nil)
        expect(orchestra.orchestra_positions.map { _1.person.birth_place }).to contain_exactly("Buenos Aires Argentina", "Buenos Aires Argentina", "Tandil (Buenos Aires) Argentina", nil)
        expect(orchestra.orchestra_positions.map { _1.person.el_recodo_person.present? }).to contain_exactly(true, true, true, true)
      end
    end

    context "when el_recodo_song does not exist" do
      it "creates a new orchestra if it doesn't exist" do
        orchestra = Import::DigitalRemaster::Builder.new.find_or_initialize_orchestra(metadata:)
        expect(orchestra.name).to eq("Aníbal Troilo")
        expect(orchestra.sort_name).to eq("Troilo, Aníbal")
      end

      it "finds an existing orchestra if it exists" do
        create(:orchestra, name: "Aníbal Troilo")
        Import::DigitalRemaster::Builder.new.find_or_initialize_orchestra(metadata:)
      end
    end
  end

  describe "#find_or_initialize_genre" do
    it "creates a new genre if it doesn’t exist" do
      genre = Import::DigitalRemaster::Builder.new.find_or_initialize_genre(metadata:)
      expect(genre.name).to eq("Vals")
    end
    it "finds an existing genre if it exists" do
      create(:genre, name: "Vals")
      Import::DigitalRemaster::Builder.new.find_or_initialize_genre(metadata:)
    end
  end

  describe "#find_or_initialize_composer" do
    it "creates a new composer if it doesn’t exist" do
      composer = Import::DigitalRemaster::Builder.new.find_or_initialize_composer(metadata:)
      expect(composer.name).to eq("Aníbal Troilo")
      expect(composer.birth_date).to be_nil
      expect(composer.death_date).to be_nil
    end
    it "finds an existing composer if it exists" do
      create(:person, name: "Aníbal Troilo")
      Import::DigitalRemaster::Builder.new.find_or_initialize_composer(metadata:)
    end
  end

  describe "#find_or_initialize_lyricist" do
    it "creates a new lyricist if it doesn’t exist" do
      lyricist = Import::DigitalRemaster::Builder.new.find_or_initialize_lyricist(metadata:)
      expect(lyricist.name).to eq("Cátulo Castillo")
      expect(lyricist.birth_date).to be_nil
      expect(lyricist.death_date).to be_nil
    end
    it "finds an existing lyricist if it exists" do
      create(:person, name: "Cátulo Castillo")
      Import::DigitalRemaster::Builder.new.find_or_initialize_lyricist(metadata:)
    end
  end

  describe "#find_or_initialize_composition" do
    it "creates a new composition if it doesn’t exist" do
      composition = Import::DigitalRemaster::Builder.new.find_or_initialize_composition(metadata:)
      expect(composition.title).to eq("Vuelve la serenata")
      expect(composition.composition_roles.find { _1.role == "composer" }.person.name).to eq("Aníbal Troilo")
      expect(composition.composition_roles.find { _1.role == "lyricist" }.person.name).to eq("Cátulo Castillo")
    end
    it "finds an existing composition if it exists" do
      create(:composition, title: "Vuelve la serenata")
      Import::DigitalRemaster::Builder.new.find_or_initialize_composition(metadata:)
    end
  end

  describe "#find_or_initialize_lyrics" do
    it "creates a new lyrics if it doesn’t exist" do
      composition = create(:composition, title: "Vuelve la serenata")
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
      create(:time_period, start_year: 1960, end_year: 1970, name: "1960s")
      time_period = Import::DigitalRemaster::Builder.new.find_existing_time_period(metadata: OpenStruct.new(date: "1953-01-01"))
      expect(time_period).to be_nil
    end

    it "returns a time period if it exists" do
      existing_time_period = create(:time_period, start_year: 1950, end_year: 1960)
      metadata = OpenStruct.new(date: "1953-01-01")
      time_period = Import::DigitalRemaster::Builder.new.find_existing_time_period(metadata:)
      expect(time_period).to eq(existing_time_period)
    end
  end

  describe "#find_or_initialize_record_label" do
    it "creates a new record label if it doesn’t exist" do
      record_label = Import::DigitalRemaster::Builder.new.find_or_initialize_record_label(metadata:)
      expect(record_label.name).to eq("Tk")
    end
    it "finds an existing record label if it exists" do
      create(:record_label, name: "Tk")
      Import::DigitalRemaster::Builder.new.find_or_initialize_record_label(metadata:)
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
      waveform_image = File.open(Rails.root.join("spec/fixtures/files/19401008_volver_a_sonar_roberto_rufino_tango_2476_waveform.png"))
      compressed_audio = File.open(Rails.root.join("spec/fixtures/files/audio/compressed/19401008_volver_a_sonar_roberto_rufino_tango_2476.mp3"))
      digital_remaster = Import::DigitalRemaster::Builder.new.build_digital_remaster(
        audio_file:,
        metadata:,
        waveform:,
        waveform_image:,
        album_art:,
        compressed_audio:
      )
      expect(digital_remaster).to be_a_new(DigitalRemaster)
      expect(digital_remaster.duration).to eq(154)
      expect(digital_remaster.bpm).to be_nil
      expect(digital_remaster.external_id).to be_nil
      expect(digital_remaster.replay_gain).to eq(-6.40)
      expect(digital_remaster.peak_value).to eq(0.994537)
      expect(digital_remaster.tango_cloud_id).to eq(7514)
      expect(digital_remaster.album).to be_a(Album)
      expect(digital_remaster.remaster_agent).to be_a(RemasterAgent)
      expect(digital_remaster.recording).to be_a(Recording)
      expect(digital_remaster.audio_file).to be_a(AudioFile)
      expect(digital_remaster.waveform).to be_a(Waveform)
      expect(digital_remaster.audio_variants).to contain_exactly(an_instance_of(AudioVariant))
      expect(digital_remaster.album.album_art).to be_attached
      expect(digital_remaster.audio_file.file).to be_attached
      expect(digital_remaster.waveform.image).to be_attached
      expect(digital_remaster.recording.singers.map(&:name)).to contain_exactly("Jorge Casal", "Raúl Berón")
      expect(digital_remaster.recording.composition.title).to eq("Vuelve la serenata")
      expect(digital_remaster.recording.composition.composition_roles.find { _1.role == "composer" }.person.name).to eq("Aníbal Troilo")
      expect(digital_remaster.recording.composition.composition_roles.find { _1.role == "lyricist" }.person.name).to eq("Cátulo Castillo")
      expect(digital_remaster.recording.orchestra.name).to eq("Aníbal Troilo")
      expect(digital_remaster.recording.genre.name).to eq("Vals")
      expect(digital_remaster.album.title).to eq("Troilo - Su Obra Completa (Soulseek)")
      expect(digital_remaster.remaster_agent.name).to eq("Tk")
      expect(digital_remaster.recording.recorded_date).to eq("1953-01-01".to_date)
      expect(digital_remaster.recording.record_label.name).to eq("Tk")
    end
  end
end
