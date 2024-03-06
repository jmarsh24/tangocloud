require "rails_helper"

RSpec.describe "period", type: :graph do
  describe "Querying for period" do
    let!(:user) { users(:admin) }
    let!(:period) { periods(:golden_age) }
    let(:query) do
      <<~GQL
        query fetchPeriod($id: ID!) {
          fetchPeriod(id: $id) {
            id
            name
          }
        }
      GQL
    end

    it "returns the correct period details" do
      gql(query, variables: {id: period.id.to_s}, user:)

      expect(data.fetch_period.id).to eq(period.id)
      expect(data.fetch_period.name).to eq("Golden Age")
    end
  end
end
