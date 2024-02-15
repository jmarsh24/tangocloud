require "rails_helper"

RSpec.describe AudioProcessing::WaveformGenerator do
  fixtures :audios
  describe "#json" do
    it "returns the json data" do
      audio = audios(:volver_a_sonar_tango_tunes_1940)
      generator = described_class.new(audio)
      binding.irb
      allow(generator).to receive(:generate_json).and_return("tmp/sets/1/1.json")
      allow(File).to receive(:read).and_return('{"data": [1,2,3]}')

      expect(generator.json).to eq({"data" => [1,2,3]})
    end
  end
end
