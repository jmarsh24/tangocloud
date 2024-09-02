require "rails_helper"

RSpec.describe "elRecodoSongs", type: :graph do
  describe "Querying for el_recodo_songs" do
    let!(:user) { create(:user, :approved) }
    let!(:volver_a_sonar) { create(:external_catalog_el_recodo_song, title: "Volver a soñar") }
    let(:query) do
      <<~GQL
        query ElRecodoSongs($query: String) {
          elRecodoSongs(query: $query) {
            edges {
              node {
                id
                title
              }
            }
          }
        }
      GQL
    end

    it "returns the correct el_recodo_song details" do
      ExternalCatalog::ElRecodo::Song.reindex
      gql(query, variables: {query: "Volver a sonar"}, user:)

      expect(data.el_recodo_songs.edges.first.node.id).to eq(volver_a_sonar.id.to_s)
      expect(data.el_recodo_songs.edges.first.node.title).to eq("Volver a soñar")
    end
  end
end
