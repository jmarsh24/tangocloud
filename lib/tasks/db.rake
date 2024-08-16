namespace :db do
  task :migrate do
    # This appends, it does not redefine.
    # Always run doc:annotate after db:migrate
    Rake::Task["doc:annotate"].invoke
  end

  namespace :export do
    desc "Export ElRecodo-related models to SQL files in the db/seeds directory"
    task el_recodo: :environment do
      def ensure_directory_exists(directory_path)
        FileUtils.mkdir_p(directory_path) unless File.directory?(directory_path)
      end

      def generate_insert_statement(table_name, attribute_names, values_array)
        "INSERT INTO #{table_name} (#{attribute_names}) VALUES #{values_array.join(", ")};"
      end

      def quote_value(value)
        if value.is_a?(Array)
          # Escape each element in the array and join them with commas
          quoted_elements = value.map { |v| ActiveRecord::Base.connection.quote(v).gsub("'", "''") }
          "'{#{quoted_elements.join(",")}}'"
        else
          ActiveRecord::Base.connection.quote(value).gsub("'", "''")
        end
      end

      def export_model_to_sql(model, sql_file_path)
        table_name = model.table_name
        attribute_names = model.column_names.map { |key| "\"#{key}\"" }.join(", ")

        # Open the SQL file for writing
        File.open(sql_file_path, "w") do |file|
          values_array = []

          model.find_each do |record|
            values = record.attributes.map { |_key, value| quote_value(value) }.join(", ")
            values_array << "(#{values})"

            if values_array.size >= 1000
              file.puts generate_insert_statement(table_name, attribute_names, values_array)
              values_array.clear
            end
          end

          # Insert any remaining records
          file.puts generate_insert_statement(table_name, attribute_names, values_array) unless values_array.empty?
        end

        puts "SQL file exported successfully for #{model.name} to #{sql_file_path}."
      end

      def export_attachments(model, attachment_name, export_directory)
        ensure_directory_exists(export_directory)

        model.find_each do |record|
          if record.send(attachment_name).attached?
            attachment = record.send(attachment_name)
            # Generate a human-readable filename
            safe_name = record.name.parameterize.underscore # Convert name to a safe filename
            file_name = "#{safe_name}_#{record.id}.#{attachment.blob.filename.extension}"
            file_path = File.join(export_directory, file_name)

            # Save the attachment to the export directory
            File.binwrite(file_path, attachment.download)

            # Save metadata about the attachment
            File.open(File.join(export_directory, "#{attachment_name}_metadata.json"), "a") do |metadata_file|
              metadata = {record_id: record.id, attachment_name:, file_name:}
              metadata_file.puts(metadata.to_json)
            end
          end
        end
      end

      # List of models to export
      models = [
        ExternalCatalog::ElRecodo::EmptyPage,
        ExternalCatalog::ElRecodo::Orchestra,
        ExternalCatalog::ElRecodo::PersonRole,
        ExternalCatalog::ElRecodo::Person,
        ExternalCatalog::ElRecodo::Song
      ]

      # Export SQL data
      models.each do |model|
        sql_file_path = Rails.root.join("db/seeds", "#{model.table_name}.sql")
        ensure_directory_exists(File.dirname(sql_file_path))
        export_model_to_sql(model, sql_file_path)
      end

      # Export attachments with unique directory names to avoid collisions
      export_attachments(ExternalCatalog::ElRecodo::Person, :image, Rails.root.join("db/seeds/images/el_recodo_people"))
      export_attachments(ExternalCatalog::ElRecodo::Orchestra, :image, Rails.root.join("db/seeds/images/el_recodo_orchestras"))
    end
  end
end
