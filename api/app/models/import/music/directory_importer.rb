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
          end
        end
      end

      def sync
        return unless Dir.exist?(@directory)

        # Fetch all filenames from the database
        existing_filenames = Audio.all.with_attached_file.map { _1.file.filename.to_s }

        Dir.glob(File.join(@directory, "**", "*")).each do |file|
          next if File.directory?(file) # Skip directories

          mime_type = MIME::Types.type_for(file).first
          next unless mime_type && SongImporter::SUPPORTED_MIME_TYPES.include?(mime_type.content_type)

          # Skip if the filename already exists in the database
          next if existing_filenames.include?(File.basename(file))
          begin
            SongImporter.new(file:).import
          rescue => e
            Rails.logger.error "Failed to sync #{file}: #{e.message}"
          end
        end
      end
    end
  end
end
