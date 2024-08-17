namespace :audio_files do
  desc "Enqueue import for all audio files that are not completed"
  task enqueue_imports: :environment do
    AudioFile.where.not(status: :completed).find_each do |audio_file|
      audio_file.import(async: true)
    end
  end

  desc "Reprocess all failed audio file imports"
  task reprocess_failed: :environment do
    AudioFile.failed.find_each do |audio_file|
      audio_file.import(async: true)
    end
  end

  desc "Check the status of all audio file imports"
  task check_statuses: :environment do
    AudioFile.find_each do |audio_file|
      puts "AudioFile #{audio_file.id}: #{audio_file.status}"
    end
  end

  desc "Import all audio files from the /app/music directory"
  task import_from_music: :environment do
    music_directory = "/app/music"

    unless Dir.exist?(music_directory)
      puts "Directory not found: #{music_directory}"
      exit(1)
    end

    Import::AudioFile::Importer.new(music_directory).sync

    puts "Audio files from #{music_directory} have been imported."
  end
end
