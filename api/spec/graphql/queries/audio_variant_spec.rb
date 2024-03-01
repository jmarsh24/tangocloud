require "rails_helper"

RSpec.describe "AudioVariant" do
  describe "Querying an audio variant" do
    let!(:user) { users(:normal) }
    let!(:audio_variant) { audio_variants(:volver_a_sonar_tango_tunes_1940_audio_variant) }

    let(:query) do
      <<~GQL
        query audioVariant($id: ID!) {
          audioVariant(id: $id) {
            id
            audioFileUrl
          }
        }
      GQL
    end

    it "returns the correct audio variant details" do
      result = TangocloudSchema.execute(query, variables: {id: audio_variant.id}, context: {current_user: user})

      audio_variant_data = result.dig("data", "audioVariant")
      expect(audio_variant_data).not_to be_nil
      expect(audio_variant_data["id"]).to eq(audio_variant.id)
      expect(audio_variant_data.dig("audioFileUrl")).to be_present
    end
  end
end
