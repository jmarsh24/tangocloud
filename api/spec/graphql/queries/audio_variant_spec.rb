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
            audioFile {
              id
              filename
              url
            }
          }
        }
      GQL
    end

    fit "returns the correct audio variant details" do
      result = TangocloudSchema.execute(query, variables: {id: audio_variant.id}, context: {current_user: user})

      audio_variant_data = result.dig("data", "audioVariant")
      expect(audio_variant_data).not_to be_nil, "Expected to find the audio variant"
      expect(audio_variant_data["id"]).to eq(audio_variant.id), "Expected audio variant ID to match"
      expect(audio_variant_data.dig("audioFile", "id")).to eq(audio_variant.audio_file.id), "Expected audio file ID to match"
      expect(audio_variant_data.dig("audioFile", "filename")).to eq(audio_variant.audio_file.filename.to_s), "Expected audio file filename to match"
      expect(audio_variant_data.dig("audioFile", "url")).to be_present, "Expected audio file URL to be present"
    end
  end
end
