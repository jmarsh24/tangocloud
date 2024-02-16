class AudioTransfer < ApplicationRecord
  belongs_to :transfer_agent
  belongs_to :recording
  belongs_to :album
  has_many :audio_variants, dependent: :destroy
  has_one :waveform, dependent: :destroy

  validates :filename, presence: true, uniqueness: true

  has_one_attached :audio_file, dependent: :purge_later
end

# == Schema Information
#
# Table name: audio_transfers
#
#  id                :uuid             not null, primary key
#  external_id       :string
#  position          :integer          default(0), not null
#  album_id          :uuid
#  transfer_agent_id :uuid
#  recording_id      :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  filename          :string           not null
#
