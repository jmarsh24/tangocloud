require "rails_helper"

RSpec.describe "users" do
  describe "Querying for users" do
    let!(:user) { users(:admin) }
    let(:query) do
      <<~GQL
        query users($query: String) {
          users(query: $query) {
            edges {
              node {
                id
                name
              }
            }
          }
        }
      GQL
    end

    it "returns the correct el_recodo_song details" do
      result = TangocloudSchema.execute(query, variables: {query: "admin"}, context: {current_user: user})

      user_data = result.dig("data", "users", "edges").map { _1["node"] }
      found_user = user_data.find { _1["name"].include?("Admin User") }

      expect(found_user).not_to be_nil
      expect(found_user["id"]).to eq(user.id.to_s)
      expect(found_user["name"]).to eq("Admin User")
    end
  end
end
