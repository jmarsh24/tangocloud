# == Schema Information
#
# Table name: album_audio_transfers
#
#  id                :uuid             not null, primary key
#  album_id          :uuid             not null
#  audio_transfer_id :uuid             not null
#  position          :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class AlbumAudioTransfer < ApplicationRecord
  belongs_to :album
  belongs_to :audio_transfer

  validates :position, presence: true, numericality: {greater_than_or_equal_to: 0}
end
