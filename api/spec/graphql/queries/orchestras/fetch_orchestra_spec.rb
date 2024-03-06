require "rails_helper"

RSpec.describe "fetchOrchestras", type: :graph do
  describe "Querying for orchestras" do
    let!(:user) { users(:normal) }
    let!(:orchestra) { orchestras(:carlos_di_sarli) }
    let(:query) do
      <<~GQL
        query FetchOrchestra($id: ID!) {
          fetchOrchestra(id: $id) {
            id
            name
          }
        }
      GQL
    end

    it "returns the correct orchestra details" do
      gql(query, variables: {id: orchestra.id}, user:)
      first_orchestra = data.fetch_orchestra

      expect(first_orchestra.id).to eq(orchestra.id)
      expect(first_orchestra.name).to eq("Carlos DI SARLI")
    end
  end
end
