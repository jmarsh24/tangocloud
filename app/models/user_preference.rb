# frozen_string_literal: true

# == Schema Information
#
# Table name: user_preferences
#
#  id         :uuid             not null, primary key
#  username   :string           not null
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

  validates :username, presence: true
  validates :locale, presence: true
  validates :user_id, presence: true
  validates :locale, inclusion: {in: ["en", "es"]}
  delegate :email, to: :user, allow_nil: true

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
