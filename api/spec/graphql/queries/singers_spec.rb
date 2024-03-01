require "rails_helper"

RSpec.describe "singers" do
  describe "Querying for singers" do
    let!(:user) { users(:admin) }
    let!(:singer) { singers(:roberto_rufino) }
    let(:query) do
      <<~GQL
        query singers($query: String) {
          singers(query: $query) {
            edges {
              node {
                id
                name
              }
            }
          }
        }
      GQL
    end

    it "returns the correct el_recodo_song details" do
      result = TangocloudSchema.execute(query, variables: {query: "rufino"}, context: {current_user: user})

      singer_data = result.dig("data", "singers", "edges").map { _1["node"] }
      found_singer = singer_data.find { _1["name"].include?("Roberto Rufino") }

      expect(found_singer).not_to be_nil
      expect(found_singer["id"]).to eq(singer.id.to_s)
      expect(found_singer["name"]).to eq("Roberto Rufino")
    end
  end
end
