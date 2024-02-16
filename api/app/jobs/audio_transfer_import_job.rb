class AudioTransferImportJob < ApplicationJob
  queue_as :import

  def perform(audio_transfer)
    Import::Music::AudioTransferImporter.new.import_from_audio_transfer(audio_transfer)
  end
end
