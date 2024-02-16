class AudioTransferImportJob < ApplicationJob
  queue_as :import

  def perform(audio_transfer)
    Import::Music::AudioTransferImporter.new(audio_transfer).import
  end
end
