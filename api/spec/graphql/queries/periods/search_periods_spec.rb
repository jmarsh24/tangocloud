require "rails_helper"

RSpec.describe "periods", type: :graph do
  describe "Querying for periods" do
    let!(:user) { users(:admin) }
    let!(:period) { periods(:golden_age) }
    let(:query) do
      <<~GQL
        query searchPeriods($query: String) {
          searchPeriods(query: $query) {
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

    it "returns the correct periods" do
      gql(query, variables: {query: "Golden Age"}, user:)

      found_periods = data.search_periods.edges.first.node
      expect(found_periods["id"]).to eq(period.id.to_s)
      expect(found_periods["name"]).to eq("Golden Age")
    end
  end
end
