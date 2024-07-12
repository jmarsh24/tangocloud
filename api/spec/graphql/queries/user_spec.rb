require "rails_helper"

RSpec.describe "user", type: :graph do
  describe "Querying for user" do
    let!(:user) { create(:user) }
    let(:query) do
      <<~GQL
        query User($id: ID!) {
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
      gql(query, variables: {id: user.id}, user:)
      user_data = data.user

      expect(user_data.id).to eq(user.id)
      expect(user_data.username).to eq(user.username)
      expect(user_data.email).to eq(user.email)
      expect(user_data.name).to eq(user.name)
      expect(user_data.first_name).to eq(user.first_name)
      expect(user_data.last_name).to eq(user.last_name)
      expect(user_data.admin).to be(false)
    end
  end
end
