class UserPreference < ApplicationRecord
  belongs_to :user

  has_one_attached :avatar do |blob|
    blob.variant :small, resize_to_limit: [160, 160], saver: {strip: true, quality: 75, lossless: false, alpha_q: 85, reduction_effort: 6, smart_subsample: true}, format: "webp"
    blob.variant :large, resize_to_limit: [500, 500], saver: {strip: true, quality: 75, lossless: false, alpha_q: 85, reduction_effort: 6, smart_subsample: true}, format: "webp"
  end

  def name=(full_name)
    self.first_name, self.last_name = full_name.to_s.squish.split(/\s/, 2)
  end

  def name
    [first_name, last_name].join(" ")
  end
end

# == Schema Information
#
# Table name: user_preferences
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
