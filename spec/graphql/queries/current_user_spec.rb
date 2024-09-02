require "rails_helper"

RSpec.describe "CurrentUser", type: :graph do
  describe "Querying for user_profile" do
    let!(:user) { create(:user, :approved) }
    let(:query) do
      <<~GQL
        query CurrentUser {
          currentUser {
            id
            username
            email
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
    end
  end
end
