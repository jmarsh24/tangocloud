require "rails_helper"

RSpec.describe "singer" do
  describe "Querying for singer" do
    let!(:user) { users(:admin) }
    let!(:singer) { singers(:roberto_rufino) }
    let(:query) do
      <<~GQL
        query singer($id: ID!) {
          singer(id: $id) {
            id
            name
          }
        }
      GQL
    end

    it "returns the correct singer details" do
      result = TangocloudSchema.execute(query, variables: {id: singer.id}, context: {current_user: user})

      singer_data = result.dig("data", "singer")

      expect(singer_data["id"]).to eq(singer.id)
      expect(singer_data["name"]).to eq("Roberto Rufino")
    end
  end
end
