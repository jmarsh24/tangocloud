namespace :db do
  task :migrate do
    # This appends, it does not redefine.
    # Always run doc:annotate after db:migrate
    Rake::Task["doc:annotate"].invoke
  end

  namespace :export do
    desc "Export ElRecodo-related models to SQL files in the db/seeds directory"
    task el_recodo: :environment do
      raise "This task is not intended for production environments." if Rails.env.production?

      def ensure_directory_exists(directory_path)
        FileUtils.mkdir_p(directory_path) unless Dir.exist?(directory_path)
      end

      def export_model_to_sql(model, sql_file_path)
        table_name = model.table_name

        ensure_directory_exists(File.dirname(sql_file_path))

        config = Rails.configuration.database_configuration[Rails.env]
        host = config["host"]
        database = config["database"]
        username = config["username"]
        rows_per_insert = 5000

        cmd = "pg_dump --host=#{host} --username=#{username} --column-inserts --data-only --rows-per-insert=#{rows_per_insert} --table=#{table_name} #{database} > #{sql_file_path}"
        system(cmd)

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
            if insert_found || line.strip.start_with?("INSERT INTO")
              insert_found = true
              new_file.write(line)
            end
          end
        end

        FileUtils.mv(temp_file_path, sql_file_path)
      end

      def export_attachments(model, attachment_name, export_directory)
        ensure_directory_exists(export_directory)

        model.find_each do |record|
          if record.send(attachment_name).attached?
            attachment = record.send(attachment_name)
            safe_name = record.name.parameterize.underscore
            file_name = "#{safe_name}_#{record.id}.#{attachment.blob.filename.extension}"
            file_path = File.join(export_directory, file_name)

            File.binwrite(file_path, attachment.download)

            File.open(File.join(export_directory, "#{attachment_name}_metadata.json"), "a") do |metadata_file|
              metadata = {record_id: record.id, attachment_name:, file_name:}
              metadata_file.puts(metadata.to_json)
            end
          end
        end
      end

      models = [
        ExternalCatalog::ElRecodo::EmptyPage,
        ExternalCatalog::ElRecodo::Orchestra,
        ExternalCatalog::ElRecodo::PersonRole,
        ExternalCatalog::ElRecodo::Person,
        ExternalCatalog::ElRecodo::Song
      ]

      models.each do |model|
        sql_file_path = Rails.root.join("db/seeds/el_recodo", "#{model.table_name}.sql")
        export_model_to_sql(model, sql_file_path)
      end

      export_attachments(ExternalCatalog::ElRecodo::Person, :image, Rails.root.join("db/seeds/el_recodo/images/el_recodo_people"))
      export_attachments(ExternalCatalog::ElRecodo::Orchestra, :image, Rails.root.join("db/seeds/el_recodo/images/el_recodo_orchestras"))
    end

    desc "Export models to SQL files in the db/seeds directory and cleanup"
    task music: :environment do
      raise "This task is not intended for production environments." if Rails.env.production?

      sample_filenames = [
        "19390201__enrique_rodriguez__te_quiero_ver_escopeta__roberto_flores__tango__TC6612_TT.flac",
        "19500922__alfredo_de_angelis__nunca_te_podre_olvidar__carlos_dante__tango__TC3674_FREE.mp3",
        "19530101__anibal_troilo__vuelve_la_serenata__jorge_casal_y_raul_beron__vals__TC7514_FREE.flac",
        "19550101__alberto_moran__ciego__armando_cupo__tango__TC5905_FREE.mp3"
      ]

      sample_audio_files = AudioFile.includes(digital_remaster: {waveform: [:waveform_datum, image_attachment: :blob], audio_variants: [audio_file_attachment: :blob]})
        .where(filename: sample_filenames)

      sample_mapping = sample_audio_files.each_with_object({}) do |audio_file, hash|
        hash[audio_file.filename] = {
          audio_file_blob_id: audio_file.file.blob.id,
          audio_variant_blob_id: audio_file.digital_remaster.audio_variants.first.audio_file.blob.id,
          digital_remaster_duration: audio_file.digital_remaster.duration,
          digital_remaster_bpm: audio_file.digital_remaster.bpm,
          digital_remaster_replay_gain: audio_file.digital_remaster.replay_gain,
          digital_remaster_peak_value: audio_file.digital_remaster.peak_value,
          waveform_datum_id: audio_file.digital_remaster.waveform.waveform_datum.id,
          waveform_image_blob_id: audio_file.digital_remaster.waveform.image.blob.id
        }
      end

      def ensure_directory_exists(directory_path)
        FileUtils.mkdir_p(directory_path) unless Dir.exist?(directory_path)
      end

      def export_model_to_sql(model, sql_file_path)
        table_name = model.table_name

        ensure_directory_exists(File.dirname(sql_file_path))

        config = Rails.configuration.database_configuration[Rails.env]
        host = config["host"]
        database = config["database"]
        username = config["username"]
        rows_per_insert = 5000

        cmd = "pg_dump --host=#{host} --username=#{username} --column-inserts --data-only --rows-per-insert=#{rows_per_insert} --table=#{table_name} #{database} > #{sql_file_path}"
        system(cmd)

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
            if insert_found || line.strip.start_with?("INSERT INTO")
              insert_found = true
              new_file.write(line)
            end
          end
        end

        FileUtils.mv(temp_file_path, sql_file_path)
      end

      def export_attachments(model, attachment_name, export_directory, sample_mapping)
        ensure_directory_exists(export_directory)

        records = model.includes(attachment_name => :blob).find_each

        records.each do |record|
          if record.send(attachment_name).attached?
            attachment = record.send(attachment_name)
            file_name = "#{record.export_filename}.#{attachment.blob.filename.extension}"
            file_path = File.join(export_directory, file_name)

            begin
              File.binwrite(file_path, attachment.blob.download)
            rescue ActiveStorage::FileNotFoundError
              puts "Missing file for #{model.name} ID #{record.id} (#{attachment_name})"
            end

            File.open(File.join(export_directory, "#{attachment_name}_metadata.json"), "a") do |metadata_file|
              metadata = {record_id: record.id, attachment_name:, file_name:}
              metadata_file.puts(metadata.to_json)
            end
          end
        end
      end

      def export_shared_blobs(blobs, export_directory, attachment_name)
        ensure_directory_exists(export_directory)

        mapping = {}

        blobs.each do |blob|
          file_name = "#{blob.id}.#{blob.filename.extension}"
          file_path = File.join(export_directory, file_name)

          begin
            File.binwrite(file_path, blob.download)
          rescue ActiveStorage::FileNotFoundError
            puts "Missing file for Blob ID #{blob.id} (#{attachment_name})"
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

        json_file_path = File.join(export_directory, "#{attachment_name}_blob_mapping.json")
        File.open(json_file_path, "w") do |json_file|
          json_file.puts(mapping.to_json)
        end

        puts "Blobs and mapping exported successfully for #{attachment_name} to #{export_directory}."
      end

      def update_tables_with_sample_mapping(sample_mapping)
        AudioFile.where.not(filename: sample_mapping.keys).find_each do |audio_file|
          sampled_data = sample_mapping.values.sample

          audio_file.file.blob.purge
          audio_file.file.update!(blob_id: sampled_data[:audio_file_blob_id])

          audio_variant = audio_file.digital_remaster.audio_variants.sole
          audio_variant.audio_file.blob.purge
          audio_variant.audio_file.update!(blob_id: sampled_data[:audio_variant_blob_id])

          digital_remaster = audio_file.digital_remaster
          digital_remaster.update!(
            duration: sampled_data[:digital_remaster_duration],
            bpm: sampled_data[:digital_remaster_bpm],
            replay_gain: sampled_data[:digital_remaster_replay_gain],
            peak_value: sampled_data[:digital_remaster_peak_value]
          )

          waveform = audio_file.digital_remaster.waveform
          waveform.waveform_datum&.destroy! if waveform.waveform_datum_id != sampled_data[:waveform_datum_id]
          waveform.image.blob.purge
          waveform.update!(waveform_datum_id: sampled_data[:waveform_datum_id])

          waveform.image.update!(blob_id: sampled_data[:waveform_image_blob_id])
        end
      end

      update_tables_with_sample_mapping(sample_mapping)

      models = [
        Album,
        AudioFile,
        AudioVariant,
        CompositionLyric,
        CompositionRole,
        Composition,
        DigitalRemaster,
        OrchestraPosition,
        OrchestraRole,
        Orchestra,
        Person,
        RecordLabel,
        RecordingSinger,
        Recording,
        RemasterAgent,
        Waveform,
        WaveformDatum
      ]

      models.each do |model|
        sql_file_path = Rails.root.join("db/seeds/music", "#{model.table_name}.sql")
        export_model_to_sql(model, sql_file_path)
      end

      export_attachments(Album, :album_art, Rails.root.join("db/seeds/music/albums"), sample_mapping)
      export_attachments(Person, :image, Rails.root.join("db/seeds/music/people"), sample_mapping)
      export_attachments(Orchestra, :image, Rails.root.join("db/seeds/music/orchestras"), sample_mapping)

      audio_file_blobs = AudioFile.all.with_attached_file.map { _1.file.blob }
      audio_variant_blobs = AudioVariant.all.with_attached_audio_file.map { _1.audio_file.blob }
      waveform_image_blobs = Waveform.all.with_attached_image.map { _1.image.blob }

      export_shared_blobs(audio_file_blobs, Rails.root.join("db/seeds/music/audio_files"), "audio_file")
      export_shared_blobs(audio_variant_blobs, Rails.root.join("db/seeds/music/audio_variants"), "audio_variant")
      export_shared_blobs(waveform_image_blobs, Rails.root.join("db/seeds/music/waveforms"), "waveform_image")
    end
  end
end
