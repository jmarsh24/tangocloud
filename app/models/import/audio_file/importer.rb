module Import
  module AudioFile
    class Importer
      MAX_THREADS = 1

      SUPPORTED_MIME_TYPES = {
        ".aiff" => "audio/x-aiff",
        ".flac" => "audio/x-flac",
        ".mp4" => "audio/mp4",
        ".mp3" => "audio/mpeg",
        ".m4a" => "audio/x-m4a"
      }.freeze

      def initialize(paths)
        @paths = Array(paths)
      end

      def sync(async: true)
        all_files = @paths.flat_map do |path|
          if File.directory?(path)
            Dir.glob(File.join(path, "**", "*")).filter_map do |file_path|
              next if File.directory?(file_path)
              [File.open(file_path), determine_mime_type(file_path)]
            end
          elsif File.file?(path)
            [[File.open(path), determine_mime_type(path)]]
          else
            []
          end
        end

        existing_filenames = ::AudioFile.pluck(:filename).compact_blank

        files_to_process = all_files.reject do |file, mime_type|
          !::AudioFile::SUPPORTED_MIME_TYPES.include?(mime_type) || existing_filenames.include?(File.basename(file))
        end

        files_to_process.each_slice(MAX_THREADS) do |file_batch|
          threads = file_batch.map do |file, _mime_type|
            Thread.new do
              import_file(file:, async:)
            end
          end
          threads.each(&:join)
        end
      end

      private

      def determine_mime_type(file_path)
        extname = File.extname(file_path).downcase
        SUPPORTED_MIME_TYPES[extname] || Marcel::MimeType.for(file_path)
      end

      def import_file(file:, async:)
        audio_file = ::AudioFile.create!(filename: File.basename(file), format: Marcel::MimeType.for(file))
        audio_file.file.attach(io: file, filename: File.basename(file))

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
