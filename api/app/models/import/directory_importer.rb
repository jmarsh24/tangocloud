module Import
  class DirectoryImporter
    MAX_THREADS = 6

    def initialize(directory)
      @directory = directory.is_a?(Dir) ? directory : Dir.new(directory.to_s)
      @semaphore = Mutex.new
    end

    def import
      process_files
    end

    def sync
      existing_filenames = AudioTransfer.all.with_attached_audio_file.map { |audio_transfer| audio_transfer.audio_file.filename.to_s }.compact_blank!

      process_files(existing_filenames)
    end

    private

    def process_files(existing_filenames = [])
      threads = []
      semaphore = Mutex.new

      each_file do |file, mime_type|
        next unless supported_mime_type?(mime_type)
        next if existing_filenames.include?(File.basename(file))

        semaphore.synchronize do
          threads << Thread.new { import_file(file) }
          if threads.size >= MAX_THREADS
            threads.first.join
            threads.shift
          end
        end
      end

      threads.each(&:join)
    end

    def each_file
      Dir.glob(File.join(@directory.path, "**", "*")).each do |file_path|
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
      audio_transfer = AudioTransfer.create!(
        filename: File.basename(file)
      )
      audio_transfer.audio_file.attach(io: file, filename: File.basename(file))

      AudioTransferImportJob.perform_later(audio_transfer)
    rescue AudioTransferImporter::DuplicateFileError
      Rails.logger.info "Duplicate file skipped: #{file.path}"
    end
  end
end
