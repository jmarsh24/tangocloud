module Import
  class DirectoryImporter
    MAX_THREADS = 1

    def initialize(directory)
      @directory = directory
    end

    def sync(async: true)
      all_files = Dir.glob(File.join(@directory, "**", "*")).filter_map do |file_path|
        next if File.directory?(file_path)

        file = File.open(file_path)
        mime_type = Marcel::MimeType.for(file)
        [file, mime_type]
      end

      existing_filenames = AudioFile.pluck(:filename).compact_blank

      files_to_process = all_files.reject do |file, mime_type|
        !AudioFile::SUPPORTED_MIME_TYPES.include?(mime_type) || existing_filenames.include?(File.basename(file))
      end

      files_to_process.each_slice(MAX_THREADS) do |file_batch|
        threads = file_batch.map do |file, _mime_type|
          Thread.new do
            audio_file = AudioFile.create!(filename: File.basename(file), format: Marcel::MimeType.for(file))
            audio_file.file.attach(io: file, filename: File.basename(file))

            Rails.logger.info("Importing #{audio_file.filename}...")

            if async
              AudioFileImportJob.perform_later(audio_file)
            else
              AudioFileImportJob.perform_now(audio_file)
            end
          end
        end
        threads.each(&:join)
      end
    end
  end
end
