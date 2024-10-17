class Tanda < ApplicationRecord
  include Playlistable

  # validate :validate_tanda_recording_count

  def validate_tanda_recording_count
    if playlist_items.size < 3
      errors.add(:base, "Tanda must have at least 3 recordings.")
    elsif playlist_items.size > 5
      errors.add(:base, "Tanda cannot have more than 5 recordings.")
    end
  end
end

# == Schema Information
#
# Table name: tandas
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  subtitle    :string
#  description :text
#  slug        :string
#  public      :boolean          default(TRUE), not null
#  system      :boolean          default(FALSE), not null
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
