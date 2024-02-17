module Import
  module Music
    class DirectoryImporter
      def initialize(directory)
        @directory = directory.to_s
      end

      def import
        return unless Dir.exist?(@directory)

        Dir.glob(File.join(@directory, "**", "*")).each do |file|
          next if File.directory?(file) # Skip directories

          mime_type = MIME::Types.type_for(file).first
          next unless mime_type && AudioTransferImporter::SUPPORTED_MIME_TYPES.include?(mime_type.content_type)

          begin
            AudioTransferImporter.new.import_from_file(file)
          rescue Import::Music::AudioTransferImporter::DuplicateFileError
            Rails.logger.info "Duplicate file skipped: #{file}"
          end
        end
      end

      def sync
        return unless Dir.exist?(@directory)

        existing_filenames = Audio.all.with_attached_file.map { |audio| audio.file.filename.to_s }

        Dir.glob(File.join(@directory, "**", "*")).each do |file|
          next if File.directory?(file)

          mime_type = MIME::Types.type_for(file).first
          next unless mime_type && AudioTransferImporter::SUPPORTED_MIME_TYPES.include?(mime_type.content_type)

          next if existing_filenames.include?(File.basename(file))

          begin
            AudioTransferImporter.new.import_from_file(file)
          rescue Import::Music::AudioTransferImporter::DuplicateFileError
            Rails.logger.info "Duplicate file skipped: #{file}"
          end
        end
      end
    end
  end
end
