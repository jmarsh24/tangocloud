require "rails_helper"

RSpec.describe "singer", type: :graph do
  describe "Querying for singer" do
    let!(:user) { users(:admin) }
    let!(:singer) { singers(:roberto_rufino) }
    let(:query) do
      <<~GQL
        query Singer($id: ID!) {
          singer(id: $id) {
            id
            name
            photoUrl
          }
        }
      GQL
    end

    it "returns the correct singer details" do
      gql(query, variables: {id: singer.id.to_s}, user:)

      expect(data.singer.id).to eq(singer.id)
      expect(data.singer.name).to eq("Roberto Rufino")
      expect(data.singer.photo_url).to be_present
    end
  end
end
