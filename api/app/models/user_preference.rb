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
class UserPreference < ApplicationRecord
  belongs_to :user

  validates :locale, presence: true
  validates :user_id, presence: true
  validates :locale, inclusion: {in: ["en", "es"]}

  before_validation :set_default_username, on: :create

  has_one_attached :avatar do |blob|
    blob.variant :small, resize_to_limit: [160, 160], saver: {strip: true, quality: 75, lossless: false, alpha_q: 85, reduction_effort: 6, smart_subsample: true}, format: "webp"
    blob.variant :large, resize_to_limit: [500, 500], saver: {strip: true, quality: 75, lossless: false, alpha_q: 85, reduction_effort: 6, smart_subsample: true}, format: "webp"
  end

  def avatar_thumbnail(width: 160)
    if avatar.attached?
      avatar.variant(:large)
    else
      Gravatar.new(user.email).url(width:)
    end
  end

  private

  def set_default_username
    return if username.present?

    base_username = user.email.split("@").first
    new_username = base_username
    counter = 1

    while UserPreference.exists?(username: new_username)
      new_username = "#{base_username}#{counter}"
      counter += 1
    end

    self.username = new_username
  end
end
