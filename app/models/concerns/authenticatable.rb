module Authenticatable
  extend ActiveSupport::Concern

  included do
    has_secure_password

    generates_token_for :email_verification, expires_in: 2.days do
      email
    end

    generates_token_for :password_reset, expires_in: 20.minutes do
      password_salt.last(10)
    end

    has_many :sessions, dependent: :destroy
    has_many :events, dependent: :destroy

    validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
    validates :password, allow_nil: true, length: {minimum: 12}

    normalizes :email, with: -> { _1.strip.downcase }

    before_validation :reset_verification_status, if: :email_changed?, on: :update

    after_update :clear_old_sessions, if: :password_digest_previously_changed?
    after_update :track_email_verification_request, if: :email_previously_changed?
    after_update :track_password_change, if: :password_digest_previously_changed?
    after_update :track_email_verification, if: [:verified_previously_changed?, :verified?]
  end

  private

  def reset_verification_status
    self.verified = false
  end

  def clear_old_sessions
    sessions.where.not(id: Current.session).delete_all
  end

  def track_email_verification_request
    events.create!(action: "email_verification_requested")
  end

  def track_password_change
    events.create!(action: "password_changed")
  end

  def track_email_verification
    events.create!(action: "email_verified")
  end
end
