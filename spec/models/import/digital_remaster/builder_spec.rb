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

  describe "#build" do
    it "builds a new digital remaster with all attributes" do
      album_art = Rails.root.join("spec/support/assets/album_art.jpg")
      waveform = AudioProcessing::WaveformGenerator::Waveform.new(
        version: 1,
        channels: 1,
        sample_rate: 44100,
        samples_per_pixel: 1024,
        bits: 16,
        length: 100,
        data: [0.1, 0.2, 0.3, 0.4]
      )
      waveform_image = Rails.root.join("spec/fixtures/files/19401008_volver_a_sonar_roberto_rufino_tango_2476_waveform.png")
      compressed_audio = Rails.root.join("spec/fixtures/files/audio/compressed/19401008_volver_a_sonar_roberto_rufino_tango_2476.mp3")
      builder = Import::DigitalRemaster::Builder.new

      digital_remaster = builder.build(
        audio_file:,
        metadata:,
        waveform:,
        waveform_image:,
        album_art:,
        compressed_audio:
      )

      expect(digital_remaster).to be_a(DigitalRemaster)
      expect(digital_remaster.duration).to eq(154)
      expect(digital_remaster.replay_gain).to eq(-6.40)
      expect(digital_remaster.peak_value).to eq(0.994537)
      expect(digital_remaster.tango_cloud_id).to eq(7514)

      expect(digital_remaster.album).to be_a(Album)
      expect(digital_remaster.album.title).to eq("Troilo - Su Obra Completa (Soulseek)")
      expect(digital_remaster.album.album_art).to be_attached

      expect(digital_remaster.remaster_agent).to be_a(RemasterAgent)
      expect(digital_remaster.remaster_agent.name).to eq("Free")

      expect(digital_remaster.recording).to be_a(Recording)
      expect(digital_remaster.recording.composition.title).to eq("Vuelve la serenata")
      expect(digital_remaster.recording.recorded_date).to eq("1953-01-01".to_date)
      expect(digital_remaster.recording.recording_type).to eq("studio")
      expect(digital_remaster.recording.orchestra.name).to eq("Aníbal Troilo")
      expect(digital_remaster.recording.genre.name).to eq("Vals")
      expect(digital_remaster.recording.composition.composers.first.name).to eq("Aníbal Troilo")
      expect(digital_remaster.recording.composition.lyricists.first.name).to eq("Cátulo Castillo")
      expect(digital_remaster.recording.recording_singers.map { _1.person.name }).to include("Jorge Casal", "Raúl Berón")
      expect(digital_remaster.recording.record_label.name).to eq("Tk")

      expect(digital_remaster.waveform).to be_a(Waveform)
      expect(digital_remaster.waveform.version).to eq(1)
      expect(digital_remaster.waveform.channels).to eq(1)
      expect(digital_remaster.waveform.sample_rate).to eq(44100)
      expect(digital_remaster.waveform.samples_per_pixel).to eq(1024)
      expect(digital_remaster.waveform.bits).to eq(16)
      expect(digital_remaster.waveform.length).to eq(100)
      expect(digital_remaster.waveform.data).to eq([0.1, 0.2, 0.3, 0.4])
      expect(digital_remaster.waveform.image).to be_attached

      expect(digital_remaster.audio_file).to eq(audio_file)

      expect(digital_remaster.audio_variants.size).to eq(1)
      audio_variant = digital_remaster.audio_variants.first
      expect(audio_variant).to be_a(AudioVariant)
      expect(audio_variant.format).to eq("flac")
      expect(audio_variant.bit_rate).to eq(558088)
      expect(audio_variant.audio_file).to be_attached
    end
  end
end
