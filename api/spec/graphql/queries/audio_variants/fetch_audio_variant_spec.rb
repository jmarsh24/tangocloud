require "rails_helper"

RSpec.describe "FetchAudioVariant", type: :graph do # Ensure you specify the type to include the GraphQLHelper
  describe "Querying an audio variant" do
    let!(:user) { users(:normal) } # Assuming users(:normal) is correctly returning a user instance
    let!(:audio_variant) { audio_variants(:volver_a_sonar_rufino_aac) } # Ensure this method correctly returns an instance

    let(:query) do
      <<~GQL
        query FetchAudioVariant($id: ID!) {
          fetchAudioVariant(id: $id) {
            id
            audioFileUrl
          }
        }
      GQL
    end

    it "returns the correct audio variant details" do
      gql(query, variables: {id: audio_variant.id.to_s}, user:)

      expect(gql_errors).to be_empty
      audio_variant_data = data.fetch_audio_variant

      expect(audio_variant_data).not_to be_nil
      expect(audio_variant_data.id).to eq(audio_variant.id.to_s)
      expect(audio_variant_data.audio_file_url).to be_present
    end
  end
end
