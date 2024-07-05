require "rails_helper"

RSpec.describe "Lyricists", type: :graph do
  describe "Querying for lyricists" do
    let!(:user) { create(:admin_user) }
    let!(:lyricist) { create(:lyricist) }
    let(:query) do
      <<~GQL
        query Lyricists($query: String) {
          lyricists(query: $query) {
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

      found_lyricist = data.lyricists.edges.first.node
      expect(found_lyricist.id).to eq(lyricist.id.to_s)
      expect(found_lyricist.name).to eq("Francisco García Jiménez")
    end
  end
end
