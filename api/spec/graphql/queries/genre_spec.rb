require "rails_helper"

RSpec.describe "genre" do
  describe "Querying for genre" do
    let!(:user) { users(:admin) }
    let!(:genre) { genres(:tango) }
    let(:query) do
      <<~GQL
        query genre($id: ID!) {
          genre(id: $id) {
            id
            name
          }
        }
      GQL
    end

    it "returns the correct el_recodo_song details" do
      result = TangocloudSchema.execute(query, variables: {id: genre.id}, context: {current_user: user})

      genre_data = result.dig("data", "genre")

      expect(genre_data["id"]).to eq(genre.id)
      expect(genre_data["name"]).to eq("tango")
    end
  end
end
