class Tanda < Playlist
  validate :validate_tanda_recording_count

  def validate_tanda_recording_count
    if playlist_items.size < 3
      errors.add(:base, "Tanda must have at least 3 recordings.")
    elsif playlist_items.size > 5
      errors.add(:base, "Tanda cannot have more than 5 recordings.")
    end
  end
end
