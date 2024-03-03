require "rails_helper"

RSpec.describe "el_recodo_songs" do
  describe "Querying for el_recodo_songs" do
    let!(:user) { users(:admin) }
    let!(:volver_a_sonar) { el_recodo_songs(:volver_a_sonar) }
    let(:query) do
      <<~GQL
        query elRecodoSongs($query: String) {
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
      result = TangocloudSchema.execute(query, variables: {query: "Volver a sonar"}, context: {current_user: user})

      el_recodo_songs_data = result.dig("data", "elRecodoSongs", "edges").map { _1["node"] }
      found_el_recodo_song = el_recodo_songs_data.find { _1["title"].include?("Volver a soñar") }

      expect(found_el_recodo_song).not_to be_nil
      expect(found_el_recodo_song["id"]).to eq(volver_a_sonar.id.to_s)
      expect(found_el_recodo_song["title"]).to eq("Volver a soñar")
    end
  end
end
