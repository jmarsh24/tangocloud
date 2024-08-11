module Import
  module AudioFile
    class ImportJob < ApplicationJob
      queue_as :import

      def perform(audio_file)
        Import::DigitalRemaster::Importer.new.import(audio_file:)
      end
    end
  end
end
