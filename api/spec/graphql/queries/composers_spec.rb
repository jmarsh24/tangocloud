require "rails_helper"

RSpec.describe "Composers", type: :graph do
  describe "Querying for composers" do
    let!(:user) { users(:admin) }
    let!(:composer) { composers(:andres_fraga) }

    let(:query) do
      <<~GQL
        query Composers($query: String) {
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
      gql(query, variables: {query: "Andres Fraga"}, user:)

      expect(data.composers.edges.first.node.id).to eq(composer.id.to_s)
      expect(data.composers.edges.first.node.name).to eq("Andres Fraga")
    end
  end
end