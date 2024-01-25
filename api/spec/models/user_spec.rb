# frozen_string_literal: true

# == Schema Information
#
# Table name: action_auth_users
#
#  id              :uuid             not null, primary key
#  email           :string
#  password_digest :string
#  verified        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  webauthn_id     :string
#
require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { User.new(email: "admin@tangocloud.app", password: "adminpassword", password_confirmation: "adminpassword") }

  describe "#create" do
    it "creates a user" do
      user.save!
      expect(User.count).to eq(1)
    end

    it "creates a user setting" do
      user.save!

      expect(user.user_setting).to be_a(UserSetting)
    end

    it "creates a user preference" do
      user.save!

      expect(user.user_preference).to be_a(UserPreference)
    end
  end

  describe "#admin?" do
    it "returns true if user is an admin" do
      user.save!
      user.user_setting.update(admin: true)

      expect(user.admin?).to be(true)
    end

    it "returns false if user is not an admin" do
      user.save!

      expect(user.admin?).to be(false)
    end
  end
end
