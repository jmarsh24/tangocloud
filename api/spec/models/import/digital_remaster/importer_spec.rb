require "rails_helper"

RSpec.describe Import::DigitalRemaster::Importer do
  let(:audio_file) { create(:flac_audio_file) }
  let(:compressed_audio) { File.open(Rails.root.join("spec/fixtures/files/audio/19401008_volver_a_sonar_roberto_rufino_tango_2476.mp3")) }
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
  let(:waveform) {
    AudioProcessing::WaveformGenerator::Waveform.new(
      version: 2,
      channels: 1,
      sample_rate: 48000,
      samples_per_pixel: 1024,
      bits: 16,
      length: 7743,
      data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    )
  }
  let(:album_art) { File.open(Rails.root.join("spec/support/assets/album_art.jpg")) }
  let(:waveform_image) { File.open(Rails.root.join("spec/fixtures/files/19401008_volver_a_sonar_roberto_rufino_tango_2476_waveform.png")) }
  let(:processor) { instance_double("AudioProcessing::AudioProcessor", process: processor, extract_metadata: metadata, generate_waveform_data: waveform, album_art:, compressed_audio:, waveform_image:) }
  let(:builder) { Import::DigitalRemaster::Builder.new }
  let(:director) { described_class.new(builder:) }

  before do
    allow(builder).to receive(:extract_metadata).and_return(metadata)
    allow(builder).to receive(:generate_waveform).and_return(waveform)
    allow(builder).to receive(:extract_album_art).and_return(album_art)
    allow(builder).to receive(:compress_audio).and_return(compressed_audio)
    allow(builder).to receive(:generate_waveform_image).and_return(waveform_image)
  end

  describe "#import" do
    it "creates an audio transfer" do
      digital_remaster = director.import(audio_file:)

      expect(digital_remaster).to be_persisted
      expect(digital_remaster.album.title).to eq("TT - Todo de Carlos -1939-1941 [FLAC]")
      expect(digital_remaster.remaster_agent.name).to eq("TangoTunes")
      expect(digital_remaster.recording.title).to eq("Volver a soñar")
    end

    it "updates the audio file status to complete on success" do
      director.import(audio_file:)
      expect(audio_file.reload.status).to eq("completed")
    end

    it "updates the audio file status to failed on error" do
      allow(builder).to receive(:build_digital_remaster).and_raise(StandardError.new("some error"))
      expect { director.import(audio_file:) }.to raise_error(StandardError, "some error")
      expect(audio_file.reload.status).to eq("failed")
    end
  end
end
