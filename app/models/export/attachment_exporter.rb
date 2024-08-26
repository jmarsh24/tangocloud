module Export
  class AttachmentExporter
    def initialize(model, attachment_name, export_directory, sample_mapping = nil)
      @model = model
      @attachment_name = attachment_name
      @export_directory = export_directory
      @sample_mapping = sample_mapping
    end

    def export
      ensure_directory_exists(@export_directory)

      records = @model.includes("#{@attachment_name}_attachment" => :blob).find_each

      records.each do |record|
        next unless record.send(@attachment_name).attached?

        attachment = record.send(@attachment_name)
        file_name = "#{record.export_filename}.#{attachment.blob.filename.extension}"
        file_path = File.join(@export_directory, file_name)

        begin
          File.binwrite(file_path, attachment.blob.download)
        rescue ActiveStorage::FileNotFoundError
          puts "Missing file for #{@model.name} ID #{record.id} (#{@attachment_name})"
        end

        File.open(File.join(@export_directory, "#{@attachment_name}_metadata.json"), "a") do |metadata_file|
          metadata = {record_id: record.id, attachment_name: @attachment_name, file_name:}
          metadata_file.puts(metadata.to_json)
        end
      end
    end

    private

    def ensure_directory_exists(directory_path)
      FileUtils.mkdir_p(directory_path) unless Dir.exist?(directory_path)
    end
  end
end
