module Import
  module AudioFile
    class Importer
      def initialize(paths)
        @paths = Array(paths)
      end

      def sync(async: true)
        all_files = @paths.flat_map do |path|
          if File.directory?(path)
            Dir.glob(File.join(path, "**", "*")).reject { |file_path| File.directory?(file_path) }
          elsif File.file?(path)
            [path]
          else
            []
          end
        end

        existing_filenames = ::AudioFile.pluck(:filename).compact_blank

        files_to_process = all_files.reject do |file_path|
          mime_type = Marcel::MimeType.for(File.open(file_path))
          !::AudioFile::SUPPORTED_MIME_TYPES.include?(mime_type) || existing_filenames.include?(File.basename(file_path))
        end

        files_to_process.each do |file_path|
          mime_type = Marcel::MimeType.for(File.open(file_path))
          audio_file = ::AudioFile.create!(filename: File.basename(file_path), format: mime_type)
          audio_file.file.attach(io: File.open(file_path), filename: File.basename(file_path))

          Rails.logger.info("Importing #{audio_file.filename}...")

          if async
            ImportJob.perform_later(audio_file)
          else
            ImportJob.perform_now(audio_file)
          end
        end
      end
    end
  end
end