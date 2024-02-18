module Import
  module Music
    class DirectoryImporter
      def initialize(directory)
        @directory = directory.is_a?(Dir) ? directory : Dir.new(directory.to_s)
      end

      def import
        each_file do |file, mime_type|
          next unless supported_mime_type?(mime_type)

          import_file(file)
        end
      end

      def sync
        existing_filenames = AudioTransfer.all.with_attached_audio_file.map { _1.audio_file.filename.to_s }

        each_file do |file, mime_type|
          next unless supported_mime_type?(mime_type) && !existing_filenames.include?(File.basename(file))

          import_file(file)
        end
      end

      private

      def each_file
        Dir.glob(File.join(@directory.path, '**', '*')).each do |file_path|
          next if File.directory?(file_path)

          file = File.open(file_path)
          mime_type = Marcel::MimeType.for(file)
          yield(file, mime_type) if block_given?
        end
      end

      def supported_mime_type?(mime_type)
        AudioTransferImporter::SUPPORTED_MIME_TYPES.include?(mime_type)
      end

      def import_file(file)
        AudioTransferImporter.new.import_from_file(file)
      rescue AudioTransferImporter::DuplicateFileError
        Rails.logger.info "Duplicate file skipped: #{file.path}"
      end
    end
  end
end
