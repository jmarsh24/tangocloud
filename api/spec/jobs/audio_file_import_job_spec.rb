require "rails_helper"

RSpec.describe AudioFileImportJob, type: :job do
  describe "#perform" do
    let(:audio_file) { create(:audio_file, :flac) }

    it "calls the importer with the correct arguments" do
      expect_any_instance_of(Import::AudioTransfer::Importer).to receive(:import).with(audio_file:)

      AudioFileImportJob.perform_now(audio_file)
    end
  end
end
