module AudioProcessing
  class AudioFolderConverter
    SUPPORTED_FORMATS = [".aif", ".flac", ".mp3"].freeze

    attr_reader :source_directory, :target_directory

    def initialize(source_directory:, target_directory: nil, target_directory_suffix: "_compressed")
      @source_directory = source_directory
      parent_directory = File.dirname(source_directory)
      source_directory_name = File.basename(source_directory)
      target_directory_name = "#{source_directory_name}#{target_directory_suffix}"
      @target_directory ||= File.join(parent_directory, target_directory_name)
    end

    def convert_all
      Dir.glob("#{source_directory}/**/*").each do |file_path|
        next if File.directory?(file_path)
        next unless SUPPORTED_FORMATS.include?(File.extname(file_path).downcase)

        relative_path = Pathname.new(file_path).relative_path_from(Pathname.new(source_directory))
        target_file_path = File.join(target_directory, relative_path)
        target_file_dir = File.dirname(target_file_path)

        FileUtils.mkdir_p(target_file_dir) unless Dir.exist?(target_file_dir)
        AudioProcessing::AudioConverter.new(output_directory: target_file_dir).convert(file: file_path.to_s)
      end
      puts "Conversion complete. Files are saved in #{target_directory}"
    end
  end
end
