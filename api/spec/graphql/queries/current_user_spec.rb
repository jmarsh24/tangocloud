require "rails_helper"

RSpec.describe "CurrentUser", type: :graph do
  describe "Querying for user_profile" do
    let!(:user) { create(:admin_user) }
    let(:query) do
      <<~GQL
        query CurrentUser {
          currentUser {
            id
            username
            email
            name
          }
        }
      GQL
    end

    it "returns the correct user details" do
      gql(query, user:)

      user_data = data.current_user

      expect(user_data.id).to eq(user.id)
      expect(user_data.username).to eq(user.username)
      expect(user_data.email).to eq(user.email)
      expect(user_data.name).to eq(user.name)
    end
  end
end
