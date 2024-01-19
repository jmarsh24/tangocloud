# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end
  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  belongs_to :account

  has_many :sessions, dependent: :destroy
  has_many :playlists, dependent: :destroy
  has_many :tandas, dependent: :destroy
  has_one :user_setting, dependent: :destroy
  has_one :user_preference, dependent: :destroy
  has_one :subscription, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, allow_nil: true, length: {minimum: 12}

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  before_validation on: :create do
    self.account = Account.new
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  delegate :admin?, to: :user_setting, allow_nil: true
  delegate :email, :username, :first_name, :last_name, to: :user_preference, allow_nil: true
end
