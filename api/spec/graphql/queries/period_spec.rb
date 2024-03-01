require "rails_helper"

RSpec.describe "period" do
  describe "Querying for period" do
    let!(:user) { users(:admin) }
    let!(:period) { periods(:golden_age) }
    let(:query) do
      <<~GQL
        query period($id: ID!) {
          period(id: $id) {
            id
            name
          }
        }
      GQL
    end

    it "returns the correct period details" do
      result = TangocloudSchema.execute(query, variables: {id: period.id}, context: {current_user: user})

      period_data = result.dig("data", "period")

      expect(period_data["id"]).to eq(period.id)
      expect(period_data["name"]).to eq("Golden Age")
    end
  end
end
