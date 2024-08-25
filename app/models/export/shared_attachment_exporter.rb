module Export
  class SharedAttachmentExporter
    def initialize(model, attachment_name, export_directory)
      @model = model
      @attachment_name = attachment_name
      @export_directory = export_directory
    end

    def export
      ensure_directory_exists(@export_directory)

      records = @model.includes("#{@attachment_name}_attachment" => :blob)

      blobs = records.map { |record| record.send(@attachment_name).blob }.uniq!(&:checksum)
      mapping = export_blobs(blobs)
      export_mapping_json(mapping)
      export_metadata(mapping)
    end

    private

    def ensure_directory_exists(directory_path)
      FileUtils.mkdir_p(directory_path) unless Dir.exist?(directory_path)
    end

    def export_blobs(blobs)
      mapping = {}

      blobs.each do |blob|
        file_name = "#{blob.id}.#{blob.filename.extension}"
        file_path = File.join(@export_directory, file_name)

        begin
          File.binwrite(file_path, blob.download)
        rescue ActiveStorage::FileNotFoundError
          puts "Missing file for Blob ID #{blob.id} (#{@attachment_name})"
        end

        mapping[blob.id] = {
          file_name:,
          metadata: {
            filename: blob.filename.to_s,
            byte_size: blob.byte_size,
            checksum: blob.checksum,
            content_type: blob.content_type,
            created_at: blob.created_at
          }
        }
      end

      mapping
    end

    def export_mapping_json(mapping)
      json_file_path = File.join(@export_directory, "#{@attachment_name}_blob_mapping.json")
      File.open(json_file_path, "w") do |json_file|
        json_file.puts(mapping.to_json)
      end
    end

    def export_metadata(mapping)
      @model.find_each do |record|
        next unless record.send(@attachment_name).attached?

        blob = record.send(@attachment_name).blob
        File.open(File.join(@export_directory, "#{@attachment_name}_metadata.json"), "a") do |metadata_file|
          metadata = {record_id: record.id, attachment_name: @attachment_name, blob_id: blob.id, file_name: mapping[blob.id][:file_name]}
          metadata_file.puts(metadata.to_json)
        end
      end
    end
  end
end
