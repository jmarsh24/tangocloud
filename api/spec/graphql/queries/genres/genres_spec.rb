require "rails_helper"

RSpec.describe "genres", type: :graph do
  describe "Querying for genres" do
    let!(:user) { users(:admin) }
    let!(:tango) { genres(:tango) }
    let(:query) do
      <<~GQL
        query searchGenres($query: String) {
          searchGenres(query: $query) {
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
      gql(query, variables: {query: "tango"}, user:)

      expect(data.search_genres.edges.first.node.id).to eq(tango.id.to_s)
      expect(data.search_genres.edges.first.node.name).to eq("tango")
    end
  end
end
