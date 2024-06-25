class User < ApplicationRecord
  include ActiveModel::SecurePassword

  has_secure_password

  def errors
    super.tap { |errors| errors.delete(:password_digest, :blank) if provider.present? }
    super.tap { |errors| errors.delete(:password, :blank) if provider.present? }
  end

  searchkick word_start: [:username, :email, :first_name, :last_name]

  has_one :user_preference, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :playlists, dependent: :destroy
  has_many :playlist_items, through: :playlists
  has_many :playbacks, dependent: :destroy
  has_many :recordings, through: :playbacks

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end
  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  has_many :sessions, dependent: :destroy
  has_many :events, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, allow_nil: true, length: {minimum: 12}, unless: -> { provider.present? }
  validates :username, presence: true, uniqueness: true, length: {minimum: 3, maximum: 32}, format: {with: /\A[a-zA-Z0-9_]+\z/}, unless: -> { provider.present? }

  normalizes :email, with: -> { _1.strip.downcase }
  normalizes :username, with: -> { _1.strip.downcase }

  after_create do
    user_preference || create_user_preference
  end

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  after_update if: :email_previously_changed? do
    events.create! action: "email_verification_requested"
  end

  after_update if: :password_digest_previously_changed? do
    events.create! action: "password_changed"
  end

  after_update if: [:verified_previously_changed?, :verified?] do
    events.create! action: "email_verified"
  end

  delegate :avatar, to: :user_preference, allow_nil: true
  delegate :first_name, :last_name, :name, to: :user_preference, allow_nil: true

  class << self
    def find_by_email_or_username(email_or_username)
      find_by(email: email_or_username) || find_by(username: email_or_username)
    end
  end

  def search_data
    {
      username:,
      email:,
      first_name:,
      last_name:,
      name:
    }
  end

  def to_s
    name
  end

  def avatar_thumbnail(width: 160)
    if avatar&.attached?
      avatar.variant(:large)
    else
      Gravatar.new(email).url(width:)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  password_digest :string
#  verified        :boolean          default(FALSE), not null
#  provider        :string
#  uid             :string
#  username        :string
#  first_name      :string
#  last_name       :string
#  admin           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
