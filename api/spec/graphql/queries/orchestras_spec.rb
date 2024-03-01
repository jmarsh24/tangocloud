require "rails_helper"

RSpec.describe "orchestras" do
  describe "Querying for orchestras" do
    let!(:user) { users(:admin) }
    let!(:orchestra) { orchestras(:carlos_di_sarli) }
    let(:query) do
      <<~GQL
        query orchestras($query: String) {
          orchestras(query: $query) {
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

    it "returns the correct orchetras" do
      result = TangocloudSchema.execute(query, variables: {query: "Di Sarli"}, context: {current_user: user})

      orchestra_data = result.dig("data", "orchestras", "edges").map { _1["node"] }
      found_orchestra = orchestra_data.find { _1["name"].include?("Carlos Di Sarli") }

      expect(found_orchestra).not_to be_nil
      expect(found_orchestra["id"]).to eq(orchestra.id.to_s)
      expect(found_orchestra["name"]).to eq("Carlos Di Sarli")
    end
  end
end
