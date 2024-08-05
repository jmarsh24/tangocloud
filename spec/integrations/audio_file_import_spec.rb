require "rails_helper"

RSpec.describe "AudioFileImport", type: :integration do
  let(:audio_file) { create(:audio_file, :mp3) }

  describe "#import" do
    it "imports the audio file" do
      expect { audio_file.import }.to change { AudioFile.count }.by(1)
    end
  end
end
