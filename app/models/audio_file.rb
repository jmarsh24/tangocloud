class AudioFile < ApplicationRecord
  searchkick word_start: [:filename], word_middle: [:filename]

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
  has_one :acr_cloud_recognition, dependent: :destroy

  validates :file, content_type: SUPPORTED_MIME_TYPES

  enum :status, {
    pending: "pending",
    processing: "processing",
    completed: "completed",
    failed: "failed"
  }

  def import(async: false)
    update(status: :processing)

    if async
      Import::AudioFile::ImportJob.perform_later(self)
    else
      Import::AudioFile::ImportJob.perform_now(self)
    end
  end

  private

  def search_data
    {
      filename: filename,
      title: extract_title_from_filename,
      orchestra: extract_orchestra_from_filename,
      date: extract_date_from_filename,
      status: status
    }
  end

  def extract_date_from_filename
    filename[/\A(\d{8})/, 1] # Extracts 'YYYYMMDD' from the start of the filename
  end

  def extract_orchestra_from_filename
    filename.split("__")[1] # Assumes orchestra name is the second part
  end

  def extract_title_from_filename
    filename.split("__")[3] # Assumes title is the fourth part
  end
end

# == Schema Information
#
# Table name: audio_files
#
#  id                      :uuid             not null, primary key
#  filename                :string           not null
#  format                  :string           not null
#  status                  :string           default("pending"), not null
#  error_message           :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  acrcloud_status         :string
#  acrcloud_fingerprint_id :string
#  acrcloud_metadata       :jsonb
#
