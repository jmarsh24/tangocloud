require "rails_helper"

RSpec.describe "orchestra" do
  describe "Querying for orchestra" do
    let!(:user) { users(:admin) }
    let!(:orchestra) { orchestras(:carlos_di_sarli) }
    let(:query) do
      <<~GQL
        query orchestra($id: ID!) {
          orchestra(id: $id) {
            id
            name
          }
        }
      GQL
    end

    it "returns the correct orchestra details" do
      result = TangocloudSchema.execute(query, variables: {id: orchestra.id}, context: {current_user: user})

      orchestra_data = result.dig("data", "orchestra")

      expect(orchestra_data["id"]).to eq(orchestra.id)
      expect(orchestra_data["name"]).to eq("Carlos Di Sarli")
    end
  end
end
