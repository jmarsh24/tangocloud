require "rails_helper"

RSpec.describe Audio, type: :model do
  describe "#file_url" do
    let(:audio) { audios(:volver_a_sonar_tango_tunes_1940) }

    it "returns the URL of the audio file" do
      expect(audio.file_url).to be_present
    end

    it "returns nil if the audio file is not attached" do
      audio.file.purge

      expect(audio.file_url).to be_nil
    end

    it "changes the url after 1 hour" do
      url = audio.file_url

      travel_to(1.hour.from_now) do
        expect(audio.file_url).not_to eq(url)
      end
    end

    it "returns the URL of the audio file with the correct disposition" do
      url = audio.file_url

      expect(url).to include("attachment")
    end

    it "has non-empty file contents" do
      expect(audio.file.byte_size).to eq(27335419)
      expect(audio.file.download).not_to be_empty
    end

    it "has the correct file type and extension" do
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
