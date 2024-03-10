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

    it "creates a liked_playlist" do
      user.reload
      expect(user.liked_playlist).to be_present
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  verified        :boolean          default(FALSE), not null
#  provider        :string
#  uid             :string
#  username        :string           not null
#  admin           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
