require "rails_helper"

RSpec.describe "lyricist" do
  describe "Querying for lyricist" do
    let!(:user) { users(:admin) }
    let!(:lyricist) { lyricists(:francisco_garcia_jimenez) }
    let(:query) do
      <<~GQL
        query lyricist($id: ID!) {
          lyricist(id: $id) {
            id
            name
          }
        }
      GQL
    end

    it "returns the correct lyricist details" do
      result = TangocloudSchema.execute(query, variables: {id: lyricist.id}, context: {current_user: user})

      lyricist_data = result.dig("data", "lyricist")

      expect(lyricist_data["id"]).to eq(lyricist.id)
      expect(lyricist_data["name"]).to eq("Francisco García Jiménez")
    end
  end
end
