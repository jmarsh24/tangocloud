namespace :db do
  namespace :db do
    task :migrate do
      Rake::Task["db:migrate"].invoke

      system("bundle exec annotate -p bottom")
    end
  end

  namespace :export do
    desc "Export ElRecodo-related models to SQL files in the db/seeds directory"
    task el_recodo: :environment do
      raise "This task is not intended for production environments." if Rails.env.production?

      models = [
        ExternalCatalog::ElRecodo::EmptyPage,
        ExternalCatalog::ElRecodo::Orchestra,
        ExternalCatalog::ElRecodo::PersonRole,
        ExternalCatalog::ElRecodo::Person,
        ExternalCatalog::ElRecodo::Song
      ]

      models.each do |model|
        sql_file_path = Rails.root.join("db/seeds/common/el_recodo", "#{model.table_name}.sql")
        Export::SqlExporter.new(model).export(sql_file_path)
      end

      Export::AttachmentExporter.new(ExternalCatalog::ElRecodo::Person, :image, Rails.root.join("db/seeds/common/el_recodo/images/el_recodo_people")).export
      Export::AttachmentExporter.new(ExternalCatalog::ElRecodo::Orchestra, :image, Rails.root.join("db/seeds/common/el_recodo/images/el_recodo_orchestras")).export
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

      sample_mapping = Export::SampleMapper.new(sample_filenames).generate_mapping
      Export::SampleMappingUpdater.new(sample_mapping).update

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
        Album, AudioFile, AudioVariant, CompositionLyric, CompositionRole, Composition,
        DigitalRemaster, Genre, Language, Lyric, OrchestraPosition, OrchestraRole, Orchestra,
        Person, RecordLabel, RecordingSinger, Recording, RemasterAgent, Waveform, WaveformDatum
      ]

      FileUtils.rm_rf(Dir.glob(Rails.root.join("db/seeds/development/music/*")))

      models.each do |model|
        sql_file_path = Rails.root.join("db/seeds/development/music", "#{model.table_name}.sql")
        Export::SqlExporter.new(model).export(sql_file_path)
      end

      Export::AttachmentExporter.new(Album, :album_art, Rails.root.join("db/seeds/development/music/albums")).export
      Export::AttachmentExporter.new(Person, :image, Rails.root.join("db/seeds/development/music/people")).export
      Export::AttachmentExporter.new(Orchestra, :image, Rails.root.join("db/seeds/development/music/orchestras")).export

      Export::SharedAttachmentExporter.new(AudioFile, :file, Rails.root.join("db/seeds/development/music/audio_files")).export
      Export::SharedAttachmentExporter.new(AudioVariant, :audio_file, Rails.root.join("db/seeds/development/music/audio_variants")).export
      Export::SharedAttachmentExporter.new(Waveform, :image, Rails.root.join("db/seeds/development/music/waveforms")).export
    end
  end
end
