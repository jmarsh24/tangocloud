require "rails_helper"

RSpec.describe "recording" do
  describe "Querying for recording" do
    let!(:user) { users(:admin) }
    let!(:recording) { recordings(:volver_a_sonar) }
    let(:query) do
      <<~GQL
        query recording($id: ID!) {
          recording(id: $id) {
            id
            title
          }
        }
      GQL
    end

    it "returns the correct recording details" do
      result = TangocloudSchema.execute(query, variables: {id: recording.id}, context: {current_user: user})

      recording_data = result.dig("data", "recording")

      expect(recording_data["id"]).to eq(recording.id)
      expect(recording_data["title"]).to eq("Volver a sonar")
    end
  end
end
