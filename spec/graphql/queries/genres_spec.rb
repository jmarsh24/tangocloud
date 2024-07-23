require "rails_helper"

RSpec.describe "Genres", type: :graph do
  describe "genres" do
    let!(:user) { create(:admin_user) }
    let!(:tango) { create(:genre, name: "Tango") }
    let(:query) do
      <<~GQL
        query Genres($query: String) {
          genres(query: $query) {
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
      Genre.reindex
      gql(query, variables: {query: "tango"}, user:)

      expect(data.genres.edges.first.node.id).to eq(tango.id.to_s)
      expect(data.genres.edges.first.node.name).to eq("Tango")
    end
  end
end
