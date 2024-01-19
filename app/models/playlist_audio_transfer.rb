# frozen_string_literal: true

# == Schema Information
#
# Table name: playlist_audio_transfers
#
#  id                :integer          not null, primary key
#  playlist_id       :integer          not null
#  audio_transfer_id :integer          not null
#  position          :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class PlaylistAudioTransfer < ApplicationRecord
  belongs_to :playlist
  belongs_to :audio_transfer

  validates :position, presence: true, numericality: {only_integer: true}
end
