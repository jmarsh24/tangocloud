class Audio < ApplicationRecord
  belongs_to :audio_transfer, dependent: :destroy
  has_many :transfer_agents, through: :audio_transfers

  has_one_attached :file, dependent: :purge_later
end

# == Schema Information
#
# Table name: audios
#
#  id                :uuid             not null, primary key
#  bit_rate          :integer
#  sample_rate       :integer
#  channels          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  codec             :string
#  length            :float
#  encoder           :string
#  metadata          :jsonb            not null
#  format            :string
#  bitrate           :integer
#  audio_transfer_id :uuid
#
