require "rails_helper"

RSpec.describe "user" do
  describe "Querying for user" do
    let!(:user) { users(:admin) }
    let(:query) do
      <<~GQL
        query user($id: ID!) {
          user(id: $id) {
            id
            name
            email
            username
            firstName
            lastName
            admin
          }
        }
      GQL
    end

    it "returns the correct user details" do
      result = TangocloudSchema.execute(query, variables: {id: user.id}, context: {current_user: user})

      user_data = result.dig("data", "user")
      expect(user_data["id"]).to eq(user.id)
      expect(user_data["username"]).to eq("admin")
      expect(user_data["email"]).to eq("admin@tangocloud.app")
      expect(user_data["name"]).to eq("Admin User")
      expect(user_data["firstName"]).to eq("Admin")
      expect(user_data["lastName"]).to eq("User")
      expect(user_data["admin"]).to be(true)
    end
  end
end
