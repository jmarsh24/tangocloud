require "rails_helper"

RSpec.describe "Composer", type: :graph do
  describe "Querying a composer" do
    let!(:user) { users(:normal) }
    let!(:composer) { composers(:andres_fraga) }

    let(:query) do
      <<~GQL
        query Composer($id: ID!) {
          composer(id: $id) {
            id
            name
            photoUrl
          }
        }
      GQL
    end

    it "returns the correct audio variant details" do
      gql(query, variables: {id: composer.id.to_s}, user:)

      expect(data.composer.id).to eq(composer.id)
      expect(data.composer.name).to eq("Andres Fraga")
      expect(data.composer.photo_url).to be_present
    end
  end
end