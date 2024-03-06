require "rails_helper"

RSpec.describe "searchLyricists", type: :graph do
  describe "Querying for lyricists" do
    let!(:user) { users(:admin) }
    let!(:lyricist) { lyricists(:francisco_garcia_jimenez) }
    let(:query) do
      <<~GQL
        query searchLyricists($query: String) {
          searchLyricists(query: $query) {
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
      gql(query, variables: {query: "Francisco García Jiménez"}, user:)

      found_lyricist = data.search_lyricists.edges.first.node
      expect(found_lyricist.id).to eq(lyricist.id.to_s)
      expect(found_lyricist.name).to eq("Francisco García Jiménez")
    end
  end
end
