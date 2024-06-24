require "rails_helper"

RSpec.describe "lyricist", type: :graph do
  describe "Querying for lyricist" do
    let!(:user) { users(:admin) }
    let!(:lyricist) { lyricists(:francisco_garcia_jimenez) }
    let(:query) do
      <<~GQL
        query Lyricist($id: ID!) {
          lyricist(id: $id) {
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

    it "returns the correct lyricist details" do
      gql(query, variables: {id: lyricist.id.to_s}, user:)

      lyricist_data = data.lyricist
      expect(lyricist_data.id).to eq(lyricist.id)
      expect(lyricist_data.name).to eq("Francisco García Jiménez")
      expect(lyricist_data.photo.blob.url).to include("http://localhost:3000/files/")
    end
  end
end
