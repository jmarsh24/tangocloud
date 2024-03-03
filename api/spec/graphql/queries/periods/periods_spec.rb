require "rails_helper"

RSpec.describe "periods" do
  describe "Querying for periods" do
    let!(:user) { users(:admin) }
    let!(:period) { periods(:golden_age) }
    let(:query) do
      <<~GQL
        query periods($query: String) {
          periods(query: $query) {
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
      result = TangocloudSchema.execute(query, variables: {query: "Golden Age"}, context: {current_user: user})

      periods_data = result.dig("data", "periods", "edges").map { _1["node"] }
      found_periods = periods_data.find { _1["name"].include?("Golden Age") }

      expect(found_periods).not_to be_nil
      expect(found_periods["id"]).to eq(period.id.to_s)
      expect(found_periods["name"]).to eq("Golden Age")
    end
  end
end
