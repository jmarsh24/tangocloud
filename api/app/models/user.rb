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
class User < ActionAuth::User
  has_many :playlists, dependent: :destroy
  has_many :tandas, dependent: :destroy
  has_one :user_setting, dependent: :destroy
  has_one :user_preference, dependent: :destroy
  has_one :subscription, dependent: :destroy, foreign_key: "action_auth_user_id", inverse_of: :user

  delegate :admin?, to: :user_setting, allow_nil: true
  delegate :admin, to: :user_setting, allow_nil: true
  delegate :username, :first_name, :last_name, :avatar, :avatar_thumbnail, to: :user_preference, allow_nil: true

  after_create_commit :create_user_setting
  after_create_commit :create_user_preference
  class << self
    def search(query)
      where("email ILIKE ?", "%#{query}%")
    end
  end
end
