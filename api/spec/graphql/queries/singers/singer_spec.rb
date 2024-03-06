require "rails_helper"

RSpec.describe "singer", type: :graph do
  describe "Querying for singer" do
    let!(:user) { users(:admin) }
    let!(:singer) { singers(:roberto_rufino) }
    let(:query) do
      <<~GQL
        query FetchSinger($id: ID!) {
          fetchSinger(id: $id) {
            id
            name
          }
        }
      GQL
    end

    it "returns the correct singer details" do
      gql(query, variables: {id: singer.id.to_s}, user:)

      expect(data.fetch_singer.id).to eq(singer.id)
      expect(data.fetch_singer.name).to eq("Roberto Rufino")
    end
  end
end
