require "rails_helper"

RSpec.describe "Composer" do
  describe "Querying a composer" do
    let!(:user) { users(:normal) }
    let!(:composer) { composers(:andres_fraga) }

    let(:query) do
      <<~GQL
        query composer($id: ID!) {
          composer(id: $id) {
            id
            name
          }
        }
      GQL
    end

    it "returns the correct audio variant details" do
      result = TangocloudSchema.execute(query, variables: {id: composer.id}, context: {current_user: user})

      composer_data = result.dig("data", "composer")

      expect(composer_data["id"]).to eq(composer.id)
      expect(composer_data["name"]).to eq("Andres Fraga")
    end
  end
end
