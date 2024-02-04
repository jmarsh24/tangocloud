class Audio < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :audio_transfer, dependent: :destroy
  has_many :transfer_agents, through: :audio_transfers

  validates :duration, presence: true
  validates :format, presence: true
  validates :bit_rate, numericality: {only_integer: true}
  validates :sample_rate, numericality: {only_integer: true}
  validates :channels, numericality: {only_integer: true}
  validates :codec, presence: true

  has_one_attached :file, dependent: :purge_later

  def file_url
    return unless file.attached?

    rails_blob_url(file, disposition: "attachment", expires_in: 1.hour)
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
#  length            :integer          default(0), not null
#  metadata          :jsonb            not null
#  audio_transfer_id :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
