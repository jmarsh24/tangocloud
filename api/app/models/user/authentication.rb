# app/models/user/authentication.rb
module User::Authentication
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword

    has_secure_password

    validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
    validates :password, allow_nil: true, length: {minimum: 12}, unless: -> { provider.present? }
    validates :username, presence: true, uniqueness: true, length: {minimum: 3, maximum: 32}, format: {with: /\A[a-zA-Z0-9_]+\z/}, unless: -> { provider.present? }

    normalizes :email, with: -> { _1.strip.downcase }
    normalizes :username, with: -> { _1.strip.downcase }

    before_validation :reset_verification, if: :email_changed?, on: :update

    after_update :clean_sessions, if: :password_digest_previously_changed?
    after_update :log_email_verification_requested, if: :email_previously_changed?
    after_update :log_password_changed, if: :password_digest_previously_changed?
    after_update :log_email_verified, if: :email_verified?
  end

  def errors
    super.tap do |errors|
      errors.delete(:password_digest, :blank) if provider.present?
      errors.delete(:password, :blank) if provider.present?
    end
  end

  private

  def reset_verification
    self.verified = false
  end

  def clean_sessions
    sessions.where.not(id: Current.session).delete_all
  end

  def log_email_verification_requested
    events.create!(action: "email_verification_requested")
  end

  def log_password_changed
    events.create!(action: "password_changed")
  end

  def log_email_verified
    events.create!(action: "email_verified")
  end

  def email_verified?
    verified_previously_changed? && verified?
  end
end
