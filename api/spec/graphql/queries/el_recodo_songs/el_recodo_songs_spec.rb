require "rails_helper"

RSpec.describe "el_recodo_songs", type: :graph do
  describe "Querying for el_recodo_songs" do
    let!(:user) { users(:admin) }
    let!(:volver_a_sonar) { el_recodo_songs(:volver_a_sonar_by_di_sarli_rufino) }
    let(:query) do
      <<~GQL
        query SearchElRecodoSongs($query: String) {
          searchElRecodoSongs(query: $query) {
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
      gql(query, variables: {query: "Volver a sonar"}, user:)

      expect(data.search_el_recodo_songs.edges.first.node.id).to eq(volver_a_sonar.id.to_s)
      expect(data.search_el_recodo_songs.edges.first.node.title).to eq("Volver a soñar")
    end
  end
end
