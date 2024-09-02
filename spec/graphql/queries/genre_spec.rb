require "rails_helper"

RSpec.describe "Genre", type: :graph do
  describe "Genre" do
    let!(:user) { create(:user, :approved) }
    let!(:genre) { create(:genre, name: "Tango") }
    let(:query) do
      <<~GQL
        query Genre($id: ID!) {
          genre(id: $id) {
            id
            name
          }
        }
      GQL
    end

    it "returns the correct el_recodo_song details" do
      gql(query, variables: {id: genre.id.to_s}, user:)

      expect(data.genre.id).to eq(genre.id)
      expect(data.genre.name).to eq("Tango")
    end
  end
end
