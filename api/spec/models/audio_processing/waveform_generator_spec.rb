require "rails_helper"

RSpec.describe AudioProcessing::WaveformGenerator do
  fixtures :audio_transfers

  describe "#json" do
    it "creates a waveform" do
      audio_transfer = audio_transfers(:volver_a_sonar_tango_tunes_1940_audio_transfer)
      audio_transfer.source_audio.open do |audio_file|
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
  end
end
