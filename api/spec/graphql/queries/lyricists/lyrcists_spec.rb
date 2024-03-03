require "rails_helper"

RSpec.describe "lyricists" do
  describe "Querying for lyricists" do
    let!(:user) { users(:admin) }
    let!(:lyricist) { lyricists(:francisco_garcia_jimenez) }
    let(:query) do
      <<~GQL
        query lyricists($query: String) {
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
      result = TangocloudSchema.execute(query, variables: {query: "francisco"}, context: {current_user: user})

      lyricist_data = result.dig("data", "lyricists", "edges").map { _1["node"] }
      found_lyricist = lyricist_data.find { _1["name"].include?("Francisco García Jiménez") }

      expect(found_lyricist).not_to be_nil
      expect(found_lyricist["id"]).to eq(lyricist.id.to_s)
      expect(found_lyricist["name"]).to eq("Francisco García Jiménez")
    end
  end
end
