require "shellwords"

module Export
  class SqlExporter
    def initialize(model)
      @model = model
    end

    def export(sql_file_path)
      ensure_directory_exists(File.dirname(sql_file_path))

      config = Rails.configuration.database_configuration[Rails.env]

      host = Shellwords.escape(config["host"])
      database = Shellwords.escape(config["database"])
      username = Shellwords.escape(config["username"])
      table_name = Shellwords.escape(@model.table_name)
      sql_file_path = Shellwords.escape(sql_file_path)
      rows_per_insert = 5000

      cmd = [
        "pg_dump",
        "--host=#{host}",
        "--username=#{username}",
        "--column-inserts",
        "--data-only",
        "--rows-per-insert=#{rows_per_insert}",
        "--table=#{table_name}",
        database,
        "> #{sql_file_path}"
      ].join(" ")

      system(cmd)

      preprocess_sql_file(sql_file_path)

      puts "SQL file exported successfully for #{@model.name} to #{sql_file_path}."
    end

    private

    def ensure_directory_exists(directory_path)
      FileUtils.mkdir_p(directory_path) unless Dir.exist?(directory_path)
    end

    def preprocess_sql_file(sql_file_path)
      temp_file_path = "#{sql_file_path}.tmp"
      insert_found = false

      File.open(temp_file_path, "w") do |new_file|
        custom_comments = <<~COMMENTS
          --
          -- Data export for table: #{@model.table_name}
          -- Exported at: #{Time.now}
          -- Total records: #{@model.count}
          --

        COMMENTS

        new_file.write(custom_comments)

        File.foreach(sql_file_path) do |line|
          if insert_found || line.strip.start_with?("INSERT INTO")
            insert_found = true
            new_file.write(line)
          end
        end
      end

      FileUtils.mv(temp_file_path, sql_file_path)
    end
  end
end
