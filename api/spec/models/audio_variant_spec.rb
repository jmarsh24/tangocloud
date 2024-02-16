require "rails_helper"

RSpec.describe AudioVariant, type: :model do
  describe "#signed_url" do
    it "returns the URL of the audio" do
      freeze_time
      audio_variant = audio_variants(:volver_a_sonar_tango_tunes_1940_audio_variant)
      expected_url = "http://localhost:3000/api/audio_variants/#{audio_variant.signed_id}"

      expect(audio_variant.signed_url).to eq(expected_url)
    end
  end
end

# == Schema Information
#
# Table name: audio_variants
#
#  id                :uuid             not null, primary key
#  duration          :integer          default(0), not null
#  format            :string           not null
#  codec             :string           not null
#  bit_rate          :integer
#  sample_rate       :integer
#  channels          :integer
#  metadata          :jsonb            not null
#  audio_transfer_id :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  filename          :string
#
