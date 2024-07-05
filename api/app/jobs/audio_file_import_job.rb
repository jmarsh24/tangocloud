class AudioFileImportJob < ApplicationJob
  queue_as :audio_file_import

  def perform(audio_file)
    builder = Import::AudioTransfer::Builder.new
    Import::AudioTransfer::Importer.new(builder:).import(audio_file:)
  end
end
