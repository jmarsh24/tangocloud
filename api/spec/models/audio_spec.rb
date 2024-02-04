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
