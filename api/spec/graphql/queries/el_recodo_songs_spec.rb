require "rails_helper"

RSpec.describe "elRecodoSongs", type: :graph do
  describe "Querying for el_recodo_songs" do
    let!(:user) { create(:admin_user) }
    let!(:volver_a_sonar) { create(:el_recodo_song, title: "Volver a soñar") }
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
      ElRecodoSong.reindex
      gql(query, variables: {query: "Volver a sonar"}, user:)

      expect(data.el_recodo_songs.edges.first.node.id).to eq(volver_a_sonar.id.to_s)
      expect(data.el_recodo_songs.edges.first.node.title).to eq("Volver a soñar")
    end
  end
end
