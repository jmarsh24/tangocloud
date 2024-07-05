# == Schema Information
#
# Table name: audio_files
#
#  id            :uuid             not null, primary key
#  filename      :string           not null
#  status        :string           default("pending"), not null
#  error_message :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe AudioFile, type: :model do
  describe "after_create_commit" do
    it "calls #import and sets the status to processing" do
      audio_file = create(:audio_file)

      expect(audio_file.status).to eq("processing")
    end

    it "enqueues an AudioFileImportJob" do
      # To test job enqueuing, you need to use ActiveJob test helpers
      ActiveJob::Base.queue_adapter = :test
      audio_file = create(:audio_file)

      expect(AudioFileImportJob).to have_been_enqueued.with(audio_file)
    end
  end

  describe "#import" do
    it "sets the status to processing" do
      audio_file = create(:audio_file)

      expect(audio_file.reload.status).to eq("processing")
    end

    it "enqueues an AudioFileImportJob" do
      ActiveJob::Base.queue_adapter = :test
      audio_file = create(:audio_file)

      expect(AudioFileImportJob).to have_been_enqueued.with(audio_file)
    end
  end
end
