require "rails_helper"

RSpec.describe "genre", type: :graph do
  describe "Querying for genre" do
    let!(:user) { users(:admin) }
    let!(:genre) { genres(:tango) }
    let(:query) do
      <<~GQL
        query FetchGenre($id: ID!) {
          fetchGenre(id: $id) {
            id
            name
          }
        }
      GQL
    end

    it "returns the correct el_recodo_song details" do
      gql(query, variables: {id: genre.id.to_s}, user:)

      expect(data.fetch_genre.id).to eq(genre.id)
      expect(data.fetch_genre.name).to eq("tango")
    end
  end
end
