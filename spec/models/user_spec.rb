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
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  username        :string
#  provider        :string
#  uid             :string
#  admin           :boolean          default(FALSE), not null
#  approved_at     :datetime
#  verified        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
