require "rails_helper"

RSpec.describe "genres" do
  describe "Querying for genres" do
    let!(:user) { users(:admin) }
    let!(:tango) { genres(:tango) }
    let(:query) do
      <<~GQL
        query genres($query: String) {
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
      result = TangocloudSchema.execute(query, variables: {query: "tango"}, context: {current_user: user})

      genre_data = result.dig("data", "genres", "edges").map { _1["node"] }
      found_genre = genre_data.find { _1["name"].include?("tango") }

      expect(found_genre).not_to be_nil
      expect(found_genre["id"]).to eq(tango.id.to_s)
      expect(found_genre["name"]).to eq("tango")
    end
  end
end
