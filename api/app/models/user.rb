# frozen_string_literal: true

class User < ApplicationRecord
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
  validates :password, not_pwned: {message: "might easily be guessed"}

  normalizes :email, with: -> { _1.strip.downcase }

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

  has_one_attached :avatar do |blob|
    blob.variant :small, resize_to_limit: [160, 160], saver: {strip: true, quality: 75, lossless: false, alpha_q: 85, reduction_effort: 6, smart_subsample: true}, format: "webp"
    blob.variant :large, resize_to_limit: [500, 500], saver: {strip: true, quality: 75, lossless: false, alpha_q: 85, reduction_effort: 6, smart_subsample: true}, format: "webp"
  end

  def avatar_thumbnail(width: 160)
    if avatar.attached?
      avatar.variant(:large)
    else
      Gravatar.new(email).url(width:)
    end
  end
end
