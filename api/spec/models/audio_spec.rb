require "rails_helper"

RSpec.describe Audio, type: :model do
  describe "#signed_url" do
    it "returns the URL of the audio" do
      freeze_time
      audio = audios(:volver_a_sonar_tango_tunes_1940)
      expected_url = "http://localhost:3000/audios/#{audio.signed_id}"

      expect(audio.signed_url).to eq(expected_url)
    end
  end

  describe "#file_url" do
    let(:audio) { audios(:volver_a_sonar_tango_tunes_1940) }

    it "returns the URL of the audio file" do
      expect(audio.file_url).to be_present
    end

    it "returns nil if the audio file is not attached" do
      audio.file.purge

      expect(audio.file_url).to be_nil
    end

    it "returns the URL of the audio file with the correct disposition" do
      expect(audio.file_url).to include("inline")
    end

    it "has the correct file type and extension" do
      audio.file.reload
      expect(audio.file.content_type).to start_with("audio/")
      expect(audio.file.filename.extension).to eq("flac")
    end
  end
end

# == Schema Information  validates :duration, presence: true
#
# Table name: audios
#
#  id                :uuid             not null, primary key
#  duration          :integer          default(0), not null
#  format            :string           not null
#  codec             :string           not null
#  bit_rate          :integer
#  sample_rate       :integer
#  channels          :integer
#  length            :integer          default(0), not null
#  metadata          :jsonb            not null
#  audio_transfer_id :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
