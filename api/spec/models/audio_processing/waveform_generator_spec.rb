require "rails_helper"

RSpec.describe AudioProcessing::WaveformGenerator do
  fixtures :audio_transfers

  describe "#json" do
    before do
      mp3_file_content = File.read(Rails.root.join("spec/fixtures/audio/19401008_volver_a_sonar_roberto_rufino_tango_2476.mp3"))
      allow_any_instance_of(FFMPEG::Movie).to receive(:transcode) do |_, output_path, _|
        File.binwrite(output_path, mp3_file_content)
      end
    end

    it "creates a waveform a flac file" do
      audio_transfer = audio_transfers(:volver_a_sonar_tango_tunes_1940_audio_transfer)
      audio_transfer.audio_file.open do |audio_file|
        waveform = described_class.new(audio_file).json
        expect(waveform.version).to eq(2)
        expect(waveform.channels).to eq(1)
        expect(waveform.sample_rate).to eq(48000)
        expect(waveform.samples_per_pixel).to eq(1024)
        expect(waveform.bits).to eq(16)
        expect(waveform.length).to eq(7743)
        expect(waveform.data).to be_a(Array)
        expect(waveform.data.length).to eq(15486)
        expect(waveform.data.first).to be_a(Float)
        expect(waveform.data.first).to be_between(-1, 1)
      end
    end

    it "creates a waveform for an mp3 file" do
      audio_file = File.open("spec/fixtures/audio/19401008_volver_a_sonar_roberto_rufino_tango_2476.mp3")
      waveform = described_class.new(audio_file).json
      expect(waveform.version).to eq(2)
      expect(waveform.channels).to eq(1)
      expect(waveform.sample_rate).to eq(48000)
      expect(waveform.samples_per_pixel).to eq(1024)
      expect(waveform.bits).to eq(16)
      expect(waveform.length).to eq(7743)
      expect(waveform.data).to be_a(Array)
      expect(waveform.data.length).to eq(15486)
      expect(waveform.data.first).to be_a(Float)
      expect(waveform.data.first).to be_between(-1, 1)
    end
  end

  describe "#image" do
    it "creates a waveform image" do
      audio_file = File.open("spec/fixtures/audio/19401008_volver_a_sonar_roberto_rufino_tango_2476.mp3")
      described_class.new(audio_file).image do |image|
        expect(Marcel::MimeType.for(File.open(image))).to eq("image/png")
        expect(ChunkyPNG::Image.from_file(image).width).to eq(800)
        expect(ChunkyPNG::Image.from_file(image).height).to eq(150)
        expect(ChunkyPNG::Image.from_file(image).pixels).to include(ChunkyPNG::Color::BLACK)
        expect(ChunkyPNG::Image.from_file(image).pixels).to include(ChunkyPNG::Color::TRANSPARENT)
      end
    end
  end
end
