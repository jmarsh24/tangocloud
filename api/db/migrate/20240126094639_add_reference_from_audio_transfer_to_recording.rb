# frozen_string_literal: true

class AddReferenceFromAudioTransferToRecording < ActiveRecord::Migration[7.1]
  def change
    add_reference :audio_transfers, :recording, foreign_key: true, type: :uuid
  end
end
