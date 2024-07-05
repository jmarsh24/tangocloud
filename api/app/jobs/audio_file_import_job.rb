class AudioFileImportJob < ApplicationJob
  queue_as :audio_file_import

  def perform(audio_file)
    builder = Import::AudioFile::Builder.new(audio_file)
    importer = Import::AudioFile::Importer.new(builder)
    audio_file = importer.import(audio_file:)
    audio_file.update(status: :completed)
  rescue => e
    audio_file.update(status: :failed, error_message: e.message)

    raise e
  end
end
