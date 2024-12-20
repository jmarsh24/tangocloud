# == Schema Information
#
# Table name: audio_files
#
#  id                      :uuid             not null, primary key
#  filename                :string           not null
#  format                  :string           not null
#  status                  :string           default("pending"), not null
#  error_message           :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  acrcloud_status         :string
#  acrcloud_fingerprint_id :string
#  acrcloud_metadata       :jsonb
#
require "rails_helper"

RSpec.describe AudioFile, type: :model do
  let(:audio_file) { create(:audio_file, :flac) }

  describe "#import" do
    it "sets the status to processing" do
      audio_file.import(async: true)

      expect(audio_file.reload.status).to eq("processing")
    end

    it "enqueues an AudioFileImportJob" do
      audio_file.import(async: true)

      expect(Import::AudioFile::ImportJob).to have_been_enqueued.with(audio_file)
    end
  end
end
