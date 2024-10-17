# == Schema Information
#
# Table name: audio_files
#
#  id            :integer          not null, primary key
#  filename      :string           not null
#  format        :string           not null
#  status        :integer          default("pending"), not null
#  error_message :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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
