require "rails_helper"

RSpec.describe "user", type: :graph do
  describe "Querying for user" do
    let!(:admin) { users(:admin) }
    let!(:normal_user) { users(:normal) }
    let(:query) do
      <<~GQL
        query fetchUser($id: ID!) {
          fetchUser(id: $id) {
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
      gql(query, variables: {id: normal_user.id.to_s}, user: admin)

      user_data = data.fetch_user

      expect(user_data.id).to eq(normal_user.id)
      expect(user_data.username).to eq("normal_user")
      expect(user_data.email).to eq("normal_user@example.com")
      expect(user_data.name).to eq("Normal User")
      expect(user_data.first_name).to eq("Normal")
      expect(user_data.last_name).to eq("User")
      expect(user_data.admin).to be(false)
    end
  end
end
