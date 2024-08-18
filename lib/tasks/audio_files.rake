namespace :audio_files do
  desc "Enqueue import for all audio files that are not completed"
  task import_all: :environment do
    audio_files = AudioFile.where(status: [:pending, :failed])

    progress_bar = ProgressBar.new(audio_files.size)

    audio_files.find_each do |audio_file|
      audio_file.import(async: true)
      progress_bar.increment!
    end

    puts "Import process for all pending and failed audio files initiated."
  end

  desc "Check the status of all audio file imports"
  task check_statuses: :environment do
    status_counts = AudioFile.group(:status).count

    puts "Audio File Import Status Overview:"
    puts "-----------------------------------"
    puts "Pending: #{status_counts["pending"] || 0}"
    puts "Processing: #{status_counts["processing"] || 0}"
    puts "Completed: #{status_counts["completed"] || 0}"
    puts "Failed: #{status_counts["failed"] || 0}"
    puts "-----------------------------------"
    puts "Total: #{AudioFile.count}"
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
