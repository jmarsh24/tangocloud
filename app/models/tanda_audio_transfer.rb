# frozen_string_literal: true

# == Schema Information
#
# Table name: tanda_audio_transfers
#
#  id         :integer          not null, primary key
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TandaAudioTransfer < ApplicationRecord
  belongs_to :tanda
  belongs_to :audio_transfer

  validates :position, presence: true
  validates :position, numericality: {only_integer: true}
  validates :tanda_id, presence: true
  validates :audio_transfer_id, presence: true
  validates :tanda_id, uniqueness: {scope: :audio_transfer_id}
end
