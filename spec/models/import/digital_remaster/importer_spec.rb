require "rails_helper"

RSpec.describe Import::DigitalRemaster::Importer do
  let(:audio_file) { create(:flac_audio_file) }
  let(:metadata_extractor) { instance_double(AudioProcessing::MetadataExtractor) }
  let(:waveform_generator) { instance_double(AudioProcessing::WaveformGenerator) }
  let(:album_art_extractor) { instance_double(AudioProcessing::AlbumArtExtractor) }
  let(:audio_converter) { instance_double(AudioProcessing::AudioConverter) }
  let(:importer) do
    described_class.new(
      metadata_extractor:,
      waveform_generator:,
      album_art_extractor:,
      audio_converter:
    )
  end
  let(:compressed_audio) { File.open(Rails.root.join("spec/fixtures/files/audio/compressed/19401008_volver_a_sonar_roberto_rufino_tango_2476.mp3")) }
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

  before do
    allow(metadata_extractor).to receive(:extract).with(file: anything).and_return(metadata)
    allow(waveform_generator).to receive(:generate).with(file: anything).and_return(waveform)
    allow(waveform_generator).to receive(:generate_image).with(file: anything).and_return(waveform_image)
    allow(album_art_extractor).to receive(:extract).with(file: anything).and_return(album_art)
    allow(audio_converter).to receive(:convert).with(file: anything).and_return(compressed_audio)
  end

  describe "#import" do
    it "creates an audio transfer" do
      digital_remaster = importer.import(audio_file:)
      expect(digital_remaster).to be_persisted
    end

    it "updates the audio file status to complete on success" do
      importer.import(audio_file:)

      expect(audio_file.reload.status).to eq("completed")
    end

    it "updates the audio file status to failed on failure" do
      allow(metadata_extractor).to receive(:extract).with(file: anything).and_raise(StandardError)
      importer.import(audio_file:)

      expect(audio_file.reload.status).to eq("failed")
      expect(audio_file.reload.error_message).to eq("StandardError")
    end
  end
end
