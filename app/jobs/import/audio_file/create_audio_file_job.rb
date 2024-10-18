module Import
  module AudioFile
    class CreateAudioFileJob < ApplicationJob
      queue_as :background

      def perform(file_path:)
        mime_type = Marcel::MimeType.for(File.open(file_path))
        audio_file = ::AudioFile.create!(filename: File.basename(file_path), format: mime_type)
        audio_file.file.attach(io: File.open(file_path), filename: File.basename(file_path))
      end
    end
  end
end
