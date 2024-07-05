require "rails_helper"

RSpec.describe "singer", type: :graph do
  describe "Querying for singer" do
    let!(:user) { create(:user) }
    let!(:singer) { create(:singer, name: "Roberto Rufino") }
    let(:query) do
      <<~GQL
        query Singer($id: ID!) {
          singer(id: $id) {
            id
            name
            photo {
              blob {
                url
              }
            }
          }
        }
      GQL
    end

    it "returns the correct singer details" do
      Singer.reindex

      gql(query, variables: {id: singer.id.to_s}, user:)

      expect(data.singer.id).to eq(singer.id)
      expect(data.singer.name).to eq("Roberto Rufino")
      expect(data.singer.photo.blob.url).to be_present
    end
  end
end
