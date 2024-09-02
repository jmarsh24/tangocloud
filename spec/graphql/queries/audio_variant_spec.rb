require "rails_helper"

RSpec.describe "AudioVariant", type: :graph do # Ensure you specify the type to include the GraphQLHelper
  describe "audioVariant" do
    let(:user) { create(:user, :approved) }
    let(:audio_variant) { create(:audio_variant) }

    let(:query) do
      <<~GQL
        query AudioVariant($id: ID!) {
          audioVariant(id: $id) {
            id
            audioFile {
              blob {
                url
              }
            }
          }
        }
      GQL
    end

    it "returns the correct audio variant details" do
      gql(query, variables: {id: audio_variant.id.to_s}, user:)

      expect(gql_errors).to be_empty
      audio_variant_data = data.audio_variant

      expect(audio_variant_data).not_to be_nil
      expect(audio_variant_data.id).to eq(audio_variant.id.to_s)
      expect(audio_variant_data.audio_file.blob.url).to be_present
    end
  end
end
