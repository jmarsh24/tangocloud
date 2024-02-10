class Audio < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :audio_transfer

  validates :duration, presence: true
  validates :format, presence: true
  validates :bit_rate, numericality: {only_integer: true}
  validates :sample_rate, numericality: {only_integer: true}
  validates :channels, numericality: {only_integer: true}
  validates :codec, presence: true
  validates :filename, presence: true, uniqueness: true

  has_one_attached :file, dependent: :purge_later

  before_validation :update_filename_from_attachment

  def signed_url
    api_audio_url(signed_id)
  end

  private

  def update_filename_from_attachment
    if file.attached? && filename != file.filename.to_s
      update_column(:filename, file.filename.to_s)
    end
  end
end

# == Schema Information
#
# Table name: audios
#
#  id                :uuid             not null, primary key
#  duration          :integer          default(0), not null
#  format            :string           not null
#  codec             :string           not null
#  bit_rate          :integer
#  sample_rate       :integer
#  channels          :integer
#  metadata          :jsonb            not null
#  audio_transfer_id :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  filename          :string
#
