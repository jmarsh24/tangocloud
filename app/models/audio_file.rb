class AudioFile < ApplicationRecord
  SUPPORTED_MIME_TYPES = [
    "audio/x-aiff",
    "audio/x-flac",
    "audio/flac",
    "audio/mp4",
    "audio/mpeg",
    "audio/x-m4a",
    "audio/mp3"
  ].freeze

  has_one_attached :file
  has_one :digital_remaster, dependent: :destroy

  validates :file, content_type: SUPPORTED_MIME_TYPES

  enum :status, {pending: 0, processed: 1, completed: 2, failed: 3}

  def import(async: false)
    update(status: :processing)

    if async
      Import::AudioFile::ImportJob.perform_later(self)
    else
      Import::AudioFile::ImportJob.perform_now(self)
    end
  end
end

# == Schema Information
#
# Table name: audio_files
#
#  id            :integer          not null, primary key
#  filename      :string           not null
#  format        :string           not null
#  status        :integer          default("pending"), not null
#  error_message :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
