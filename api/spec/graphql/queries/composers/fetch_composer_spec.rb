require "rails_helper"

RSpec.describe "FetchComposer", type: :graph do
  describe "Querying a composer" do
    let!(:user) { users(:normal) }
    let!(:composer) { composers(:andres_fraga) }

    let(:query) do
      <<~GQL
        query fetchComposer($id: ID!) {
          fetchComposer(id: $id) {
            id
            name
            photoUrl
          }
        }
      GQL
    end

    it "returns the correct audio variant details" do
      gql(query, variables: {id: composer.id.to_s}, user:)

      expect(data.fetch_composer.id).to eq(composer.id)
      expect(data.fetch_composer.name).to eq("Andrés Fraga")
      expect(data.fetch_composer.photo_url).to be_present
    end
  end
end
