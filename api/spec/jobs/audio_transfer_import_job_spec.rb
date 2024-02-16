require "rails_helper"

RSpec.describe AudioTransferImportJob, type: :job do
  describe "#perform" do
    it "calls the import_from_audio_transfer method on the AudioTransferImporter" do
      audio_transfer = instance_double(AudioTransfer)
      audio_transfer_importer = instance_double(Import::Music::AudioTransferImporter)
      allow(Import::Music::AudioTransferImporter).to receive(:new).and_return(audio_transfer_importer)
      expect(audio_transfer_importer).to receive(:import_from_audio_transfer).with(audio_transfer)
      described_class.perform_now(audio_transfer)
    end
  end
end
