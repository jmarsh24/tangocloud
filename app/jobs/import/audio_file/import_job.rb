module Import
  module AudioFile
    class ImportJob < ApplicationJob
      queue_as :import

      def perform(audio_file)
        builder = Import::DigitalRemaster::Builder.new
        Import::DigitalRemaster::Importer.new(builder:).import(audio_file:)
      end
    end
  end
end
