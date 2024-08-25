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

      models = [
        ExternalCatalog::ElRecodo::EmptyPage,
        ExternalCatalog::ElRecodo::Orchestra,
        ExternalCatalog::ElRecodo::PersonRole,
        ExternalCatalog::ElRecodo::Person,
        ExternalCatalog::ElRecodo::Song
      ]

      models.each do |model|
        sql_file_path = Rails.root.join("db/seeds/el_recodo", "#{model.table_name}.sql")
        Export::SqlExporter.new(model).export(sql_file_path)
      end

      Export::AttachmentExporter.new(ExternalCatalog::ElRecodo::Person, :image, Rails.root.join("db/seeds/el_recodo/images/el_recodo_people")).export
      Export::AttachmentExporter.new(ExternalCatalog::ElRecodo::Orchestra, :image, Rails.root.join("db/seeds/el_recodo/images/el_recodo_orchestras")).export
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

      models = [
        Album, AudioFile, AudioVariant, CompositionLyric, CompositionRole, Composition,
        DigitalRemaster, Genre, Language, Lyric, OrchestraPosition, OrchestraRole, Orchestra,
        Person, RecordLabel, RecordingSinger, Recording, RemasterAgent, Waveform, WaveformDatum
      ]

      FileUtils.rm_rf(Dir.glob(Rails.root.join("db/seeds/music/*")))

      models.each do |model|
        sql_file_path = Rails.root.join("db/seeds/music", "#{model.table_name}.sql")
        Export::SqlExporter.new(model).export(sql_file_path)
      end

      Export::AttachmentExporter.new(Album, :album_art, Rails.root.join("db/seeds/music/albums")).export
      Export::AttachmentExporter.new(Person, :image, Rails.root.join("db/seeds/music/people")).export
      Export::AttachmentExporter.new(Orchestra, :image, Rails.root.join("db/seeds/music/orchestras")).export

      Export::SharedAttachmentExporter.new(AudioFile, :file, Rails.root.join("db/seeds/music/audio_files")).export
      Export::SharedAttachmentExporter.new(AudioVariant, :audio_file, Rails.root.join("db/seeds/music/audio_variants")).export
      Export::SharedAttachmentExporter.new(Waveform, :image, Rails.root.join("db/seeds/music/waveforms")).export
    end
  end
end
