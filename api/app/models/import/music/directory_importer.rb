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
          next unless mime_type && SongImporter::SUPPORTED_MIME_TYPES.include?(mime_type.content_type)

          begin
            SongImporter.new(file:).import
          rescue => e
            Rails.logger.error "Failed to import #{file}: #{e.message}"
            raise e
          end
        end
      end
    end
  end
end
