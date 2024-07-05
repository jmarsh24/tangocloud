require "rails_helper"

RSpec.describe "lyricist", type: :graph do
  describe "Querying for lyricist" do
    let!(:user) { create(:admin_user) }
    let!(:lyricist) { create(:lyricist, name: "Francisco García Jiménez") }
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
      Lyricist.reindex
      gql(query, variables: {id: lyricist.id.to_s}, user:)

      lyricist_data = data.lyricist
      expect(lyricist_data.id).to eq(lyricist.id)
      expect(lyricist_data.name).to eq("Francisco García Jiménez")
      expect(lyricist_data.photo.blob.url).to be_present
    end
  end
end
