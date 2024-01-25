# frozen_string_literal: true

# == Schema Information
#
# Table name: user_preferences
#
#  id         :uuid             not null, primary key
#  username   :string
#  first_name :string
#  last_name  :string
#  gender     :string
#  birth_date :string
#  locale     :string           default("en"), not null
#  user_id    :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe UserPreference, type: :model do
  describe "#user_avatar" do
    it "returns gravatar if no avatar attached" do
      user = User.find_or_create_by!(email: "admin@tangocloud.app", password: "adminpassword", password_confirmation: "adminpassword")
      expect(user.avatar_thumbnail).to eq("https://www.gravatar.com/avatar/db28ff81643ae82b641f7ac3905975a1?d=mm&s=160")
    end

    it "returns avatar if attached" do
      user = User.find_or_create_by!(email: "admin@tangocloud.app", password: "adminpassword", password_confirmation: "adminpassword")
      user.avatar.attach(io: File.open(Rails.root.join("spec", "fixtures", "files", "tangocloud_logo.png")), filename: "tangocloud_logo.png", content_type: "image/png")

      expect(user.avatar_thumbnail.filename.to_s).to include("tangocloud_logo.webp")
    end
  end
end
