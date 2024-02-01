module Import
  module Music
    class DirectoryImporter
      def initialize(directory_path)
        @directory_path = directory_path
      end

      def import
        return unless Dir.exist?(@directory_path)

        Dir.glob(File.join(@directory_path, "*")).each do |file_path|
          next unless MusicImporter::SUPPORTED_FORMATS.include?(File.extname(file_path).downcase)

          begin
            MusicImporter.new(file_path).import
          rescue => e
            Rails.logger.error "Failed to import #{file_path}: #{e.message}"
            # Handle the error as per your requirement
          end
        end
      end
    end
  end
end
