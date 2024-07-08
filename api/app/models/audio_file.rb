# == Schema Information
#
# Table name: audio_files
#
#  id            :uuid             not null, primary key
#  filename      :string           not null
#  format        :string           not null
#  status        :string           default("pending"), not null
#  error_message :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class AudioFile < ApplicationRecord
  SUPPORTED_MIME_TYPES = [
    "audio/x-flac",
    "audio/flac",
    "audio/mp3"
  ]

  has_one_attached :file
  has_one :audio_transfer, dependent: :destroy

  validates :file, content_type: SUPPORTED_MIME_TYPES

  enum status: {
    pending: "pending",
    processing: "processing",
    completed: "completed",
    failed: "failed"
  }

  def import
    update(status: :processing)

    AudioFileImportJob.perform_later(self)
  end
end
