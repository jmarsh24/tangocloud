module Import
  class DirectoryImporter
    MAX_THREADS = 6

    def initialize(directory)
      @directory = directory
    end

    def sync
      existing_filenames = AudioFile.pluck(:filename).compact_blank

      process_files(existing_filenames)
    end

    private

    def process_files(existing_filenames)
      files_to_process = each_file.reject do |file, mime_type|
        !supported_mime_type?(mime_type) || existing_filenames.include?(File.basename(file))
      end

      files_to_process.each_slice(MAX_THREADS) do |file_batch|
        threads = file_batch.map do |file, _mime_type|
          Thread.new { import_file(file) }
        end
        threads.each(&:join)
      end
    end

    def each_file
      Dir.glob(File.join(@directory, "**", "*")).filter_map do |file_path|
        next if File.directory?(file_path)

        file = File.open(file_path)
        mime_type = Marcel::MimeType.for(file)
        [file, mime_type]
      end
    end

    def supported_mime_type?(mime_type)
      AudioFile::SUPPORTED_MIME_TYPES.include?(mime_type)
    end

    def import_file(file)
      audio_file = AudioFile.create!(filename: File.basename(file))
      audio_file.file.attach(io: file, filename: File.basename(file))

      AudioFileImportJob.perform_later(audio_file)
    end
  end
end
