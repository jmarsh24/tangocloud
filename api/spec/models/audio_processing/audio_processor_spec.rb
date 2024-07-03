require "rails_helper"

RSpec.describe AudioProcessing::AudioProcessor do
  let(:file) { File.open(file_fixture("audio/19401008__volver_a_sonar__roberto_rufino__tango.flac")) }

  describe "#process" do
    context "when song is from flac" do
      before do
        allow_any_instance_of(AudioProcessing::AudioConverter).to receive(:convert).and_return(
          File.open(file_fixture("audio/19421009_no_te_apures_carablanca_juan_carlos_miranda_tango_1918.m4a"))
        )
        allow_any_instance_of(AudioProcessing::WaveformGenerator).to receive(:json).and_return(
          Waveform.new(
            version: 2,
            channels: 1,
            sample_rate: 48000,
            samples_per_pixel: 1024,
            bits: 16,
            length: 7743,
            data: [0.0, 0.1, 0.3]
          )
        )
        allow_any_instance_of(AudioProcessing::WaveformGenerator).to receive(:image).and_return(
          File.open(file_fixture("19401008_volver_a_sonar_roberto_rufino_tango_2476_waveform.png"))
        )

        allow_any_instance_of(AudioProcessing::AlbumArtExtractor).to receive(:extract).and_return(
          File.open(file_fixture("album-art-volver-a-sonar.jpg"))
        )

        allow_any_instance_of(AudioProcessing::MetadataExtractor).to receive(:extract).and_return(
          AudioProcessing::MetadataExtractor::Metadata.new(
            duration: 165.158396,
            bit_rate: 1325044,
            bit_depth: 24,
            bit_rate_mode: nil,
            codec_name: "flac",
            codec_long_name: "FLAC (Free Lossless Audio Codec)",
            sample_rate: 96000,
            channels: 1,
            title: "Volver a soñar",
            artist: "Roberto Rufino",
            album: "TT - Todo de Carlos -1939-1941 [FLAC]",
            date: "1940-10-08",
            track: nil,
            genre: "Tango",
            album_artist: "Carlos Di Sarli",
            catalog_number: nil,
            composer: "Andrés Fraga",
            performer: nil,
            record_label: "Rca Victor",
            encoded_by: nil,
            singer: "Roberto Rufino",
            media_type: nil,
            lyrics:
              "No sé si fue mi mano\r\nO fue la tuya\r\nQue escribió,\r\nLa carta del adiós\r\nEn nuestro amor.\r\n \r\nNo quiero ni saber\r\nQuién fue culpable\r\nDe los dos,\r\nNi pido desazones\r\nNi rencor.\r\n \r\nMe queda del ayer\r\nEnvuelto en tu querer,\r\nEl rastro de un perfume antiguo.\r\nMe queda de tu amor\r\nEl lánguido sabor\r\nDe un néctar\r\nQue ya nunca beberé.\r\n \r\nPor eso que esta estrofa\r\nAl muerto idilio, no es capaz,\r\nDe hacerlo entre los dos resucitar.\r\nSi acaso algo pretendo\r\nEs por ofrenda al corazón,\r\nSalvarlo del olvido, nada más...",
            format: "flac",
            bpm: nil,
            ert_number: 2476,
            source: "FREE",
            lyricist: "Francisco García Jiménez",
            artist_sort: "Di Sarli, Carlos"
          )
        )
      end

      describe "#process" do
        it "calls the necessary methods to process the audio file" do
          processor = AudioProcessing::AudioProcessor.new(file:)

          expect(processor).to receive(:extract_waveform).and_call_original
          expect(processor).to receive(:convert_audio).and_call_original
          expect(processor).to receive(:extract_album_art).and_call_original
          expect(processor).to receive(:extract_metadata).and_call_original

          processor.process
        end

        it "sets the correct attributes after processing" do
          processor = AudioProcessing::AudioProcessor.new(file:).process

          expect(processor.waveform_image).to be_a(File)
          expect(processor.waveform_data).to be_a(Waveform)
          expect(processor.compressed_audio).to be_a(File)
          expect(processor.album_art).to be_a(File)
          expect(processor.metadata).to be_a(AudioProcessing::MetadataExtractor::Metadata)
        end
      end
    end
  end
end
