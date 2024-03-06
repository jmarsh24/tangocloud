require "rails_helper"

RSpec.describe "search orchestras", type: :graph do
  let!(:user) { users(:admin) }
  let!(:el_recodo) { orchestras(:carlos_di_sarli) }
  let(:query) do
    <<~GQL
      query SearchOrchestras($query: String) {
        searchOrchestras(query: $query) {
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

  it "returns the correct orchestras" do
    gql(query, variables: {query: "Carlos Di Sarli"}, user:)

    found_orchestra = data.search_orchestras.edges.first.node
    expect(found_orchestra.id).to eq(el_recodo.id.to_s)
    expect(found_orchestra.name).to eq("Carlos DI SARLI")
  end
end
