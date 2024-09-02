require "rails_helper"

RSpec.describe "orchestras", type: :graph do
  let!(:user) { create(:user, :approved) }
  let!(:el_recodo) { create(:orchestra, name: "Carlos Di Sarli") }
  let(:query) do
    <<~GQL
      query Orchestras($query: String) {
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

  it "returns the correct orchestras" do
    Orchestra.reindex

    gql(query, variables: {query: "Carlos Di Sarli"}, user:)

    found_orchestra = data.orchestras.edges.first.node
    expect(found_orchestra.id).to eq(el_recodo.id.to_s)
    expect(found_orchestra.name).to eq("Carlos Di Sarli")
  end
end
