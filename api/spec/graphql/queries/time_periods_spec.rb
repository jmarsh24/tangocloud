require "rails_helper"

RSpec.describe "Periods", type: :graph do
  describe "Querying for periods" do
    let!(:user) { create(:user) }
    let!(:time_period) { create(:time_period, name: "Golden Age") }
    let(:query) do
      <<~GQL
        query TimePeriods($query: String) {
          timePeriods(query: $query) {
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
      TimePeriod.reindex

      gql(query, variables: {query: "Golden Age"}, user:)

      found_time_periods = data.time_periods.edges.first.node
      expect(found_time_periods["id"]).to eq(time_period.id.to_s)
      expect(found_time_periods["name"]).to eq("Golden Age")
    end
  end
end
