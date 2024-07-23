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
#  id                     :uuid             not null, primary key
#  username               :string
#  admin                  :boolean          default(FALSE), not null
#  provider               :string
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#
