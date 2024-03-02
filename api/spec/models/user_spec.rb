require "rails_helper"

RSpec.describe User, type: :model do
  describe "create" do
    let(:user) do
      User.create!(
        email: "user@example.com",
        password: "examplepassword123",
        username: "user"
      )
    end

    it "creates a user_preference" do
      user.reload
      expect(user.user_preference).to be_present
    end

    it "creates a user_history" do
      user.reload
      expect(user.user_history).to be_present
    end
  end
end
