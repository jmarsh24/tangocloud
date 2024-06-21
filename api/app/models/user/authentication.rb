class User
  module Authentication
    extend ActiveSupport::Concern

    included do
      include ActiveModel::SecurePassword
      has_secure_password
      has_many :sessions, dependent: :destroy
      has_many :events, dependent: :destroy

      validates :username, presence: true, uniqueness: true, length: {minimum: 3, maximum: 32}, format: {with: /\A[a-zA-Z0-9_]+\z/}, unless: -> { provider.present? }
      validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
      validates :password, allow_nil: true, length: {minimum: 12}

      before_validation :set_verified_false_if_email_changed, on: :update
      after_update :clear_sessions_if_password_digest_changed
      after_update :create_email_verification_event_if_email_changed
      after_update :create_password_changed_event_if_password_digest_changed
      after_update :create_email_verified_event_if_verified_changed

      normalizes :email, with: -> { _1.strip.downcase }
      normalizes :username, with: -> { _1.strip.downcase }
    end

    class_methods do
      generates_token_for :email_verification, expires_in: 2.days do
        email
      end

      generates_token_for :password_reset, expires_in: 20.minutes do
        password_salt.last(10)
      end
    end

    private

    def set_verified_false_if_email_changed
      self.verified = false if email_changed?
    end

    def clear_sessions_if_password_digest_changed
      sessions.where.not(id: Current.session).delete_all if password_digest_previously_changed?
    end

    def create_email_verification_event_if_email_changed
      events.create!(action: "email_verification_requested") if email_previously_changed?
    end

    def create_password_changed_event_if_password_digest_changed
      events.create!(action: "password_changed") if password_digest_previously_changed?
    end

    def create_email_verified_event_if_verified_changed
      events.create!(action: "email_verified") if verified_previously_changed? && verified?
    end
  end
end
