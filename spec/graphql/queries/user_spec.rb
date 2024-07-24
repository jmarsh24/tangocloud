require "rails_helper"

RSpec.describe "user", type: :graph do
  describe "Querying for user" do
    let!(:user) { create(:user) }
    let(:query) do
      <<~GQL
        query User($id: ID!) {
          user(id: $id) {
            id
            email
            username
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
      expect(user_data.admin).to be(false)
    end
  end
end
