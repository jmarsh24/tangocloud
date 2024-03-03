require "rails_helper"

RSpec.describe "Composers" do
  describe "Querying for composers" do
    let!(:user) { users(:admin) }
    let!(:composer) { composers(:andres_fraga) }

    let(:query) do
      <<~GQL
        query composers($query: String) {
          composers(query: $query) {
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

    it "returns the correct composer details" do
      result = TangocloudSchema.execute(query, variables: {query: "Andres Fraga"}, context: {current_user: user})

      composers_data = result.dig("data", "composers", "edges").map { |edge| edge["node"] }
      found_composer = composers_data.find { |composer| composer["name"].include?("Andres Fraga") }
      expect(found_composer).not_to be_nil
      expect(found_composer["id"]).to eq(composer.id.to_s)
      expect(found_composer["name"]).to eq("Andres Fraga")
    end
  end
end
