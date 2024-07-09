class AudioFileImportJob < ApplicationJob
  queue_as :audio_file_import

  def perform(audio_file)
    builder = Import::DigitalRemaster::Builder.new
    Import::DigitalRemaster::Importer.new(builder:).import(audio_file:)
  end
end
