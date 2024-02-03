class PlaylistAudioTransfer < ApplicationRecord
  belongs_to :playlist
  belongs_to :audio_transfer

  validates :position, presence: true, numericality: {only_integer: true}
end

# == Schema Information
#
# Table name: playlist_audio_transfers
#
#  id                :uuid             not null, primary key
#  playlist_id       :uuid             not null
#  audio_transfer_id :uuid             not null
#  position          :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
