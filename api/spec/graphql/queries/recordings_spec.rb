require "rails_helper"

RSpec.describe "recordings" do
  describe "Querying for recordings" do
    let!(:user) { users(:admin) }
    let!(:recording) { recordings(:volver_a_sonar) }
    let(:query) do
      <<~GQL
        query recordings($query: String) {
          recordings(query: $query) {
            edges {
              node {
                id
                title
              }
            }
          }
        }
      GQL
    end

    it "returns the correct orchetras" do
      result = TangocloudSchema.execute(query, variables: {query: "Volver a"}, context: {current_user: user})

      recording_data = result.dig("data", "recordings", "edges").map { _1["node"] }
      found_recording = recording_data.find { _1["title"].include?("Volver a sonar") }

      expect(found_recording).not_to be_nil
      expect(found_recording["id"]).to eq(recording.id.to_s)
      expect(found_recording["title"]).to eq("Volver a sonar")
    end
  end
end
