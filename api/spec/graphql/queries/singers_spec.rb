require "rails_helper"

RSpec.describe "singers", type: :graph do
  describe "Querying for singers" do
    let!(:user) { users(:admin) }
    let!(:singer) { singers(:roberto_rufino) }
    let(:query) do
      <<~GQL
        query Singers($query: String!) {
          singers(query: $query) {
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

    it "returns the correct el_recodo_song details" do
      gql(query, variables: {query: "Roberto"}, user:)

      found_singer = data.singers.edges.first.node

      expect(found_singer["id"]).to eq(singer.id.to_s)
      expect(found_singer["name"]).to eq("Roberto Rufino")
    end
  end
end
