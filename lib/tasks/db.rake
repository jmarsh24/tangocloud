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
        FileUtils.mkdir_p(directory_path) unless Dir.exist?(directory_path)
      end

      def export_model_to_sql(model, sql_file_path)
        table_name = model.table_name

        # Ensure the directory exists
        ensure_directory_exists(File.dirname(sql_file_path))

        # Database configuration
        config = Rails.configuration.database_configuration[Rails.env]
        host = config["host"]
        database = config["database"]
        username = config["username"]
        rows_per_insert = 5000

        # Construct the pg_dump command with --data-only
        cmd = "pg_dump --host=#{host} --username=#{username} --column-inserts --data-only --rows-per-insert=#{rows_per_insert} --table=#{table_name} #{database} > #{sql_file_path}"

        # Execute the command
        system(cmd)

        # Preprocess the SQL file to remove unnecessary comments and add custom ones
        preprocess_sql_file(sql_file_path, model)

        puts "SQL file exported successfully for #{model.name} to #{sql_file_path}."
      end

      def preprocess_sql_file(sql_file_path, model)
        temp_file_path = "#{sql_file_path}.tmp"
        insert_found = false

        File.open(temp_file_path, "w") do |new_file|
          custom_comments = <<~COMMENTS
            --
            -- Data export for table: #{model.table_name}
            -- Exported at: #{Time.now}
            -- Total records: #{model.count}
            --

          COMMENTS

          new_file.write(custom_comments)

          File.foreach(sql_file_path) do |line|
            # Only start writing lines after finding the first INSERT statement
            if insert_found || line.strip.start_with?("INSERT INTO")
              insert_found = true
              new_file.write(line)
            end
          end
        end

        # Replace the original file with the preprocessed file
        FileUtils.mv(temp_file_path, sql_file_path)
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
        export_model_to_sql(model, sql_file_path)
      end

      # Export attachments with unique directory names to avoid collisions
      export_attachments(ExternalCatalog::ElRecodo::Person, :image, Rails.root.join("db/seeds/images/el_recodo_people"))
      export_attachments(ExternalCatalog::ElRecodo::Orchestra, :image, Rails.root.join("db/seeds/images/el_recodo_orchestras"))
    end
  end
end
