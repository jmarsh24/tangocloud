# == Schema Information
#
# Table name: audio_files
#
#  id            :uuid             not null, primary key
#  filename      :string           not null
#  status        :string           default("pending"), not null
#  error_message :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class AudioFile < ApplicationRecord
  has_one_attached :file
  has_one :audio_transfer, dependent: :destroy

  validates :file, attached: true, content_type: [
    "audio/x-aiff",
    "audio/x-flac",
    "audio/flac",
    "audio/mp4",
    "audio/mpeg",
    "audio/x-m4a",
    "audio/mp3"
  ]

  enum status: {
    pending: "pending",
    processing: "processing",
    completed: "completed",
    failed: "failed"
  }

  after_create_commit :import

  def import
    update(status: :processing)

    AudioFileImportJob.perform_later(self)
  end
end
