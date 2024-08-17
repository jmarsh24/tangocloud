puts "Seeding music data..."

# List of SQL files to be seeded
sql_files = [
  "albums.sql",
  "audio_files.sql",
  "audio_variants.sql",
  "composition_lyrics.sql",
  "composition_roles.sql",
  "compositions.sql",
  "digital_remasters.sql",
  "orchestra_positions.sql",
  "orchestra_roles.sql",
  "orchestras.sql",
  "people.sql",
  "record_labels.sql",
  "recording_singers.sql",
  "recordings.sql",
  "remaster_agents.sql",
  "waveforms.sql"
]

puts "Seeding SQL files..."

progressbar = ProgressBar.create(total: sql_files.size)

sql_files.each do |file_name|
  file_path = Rails.root.join("db/seeds/music", file_name)

  if File.exist?(file_path)
    puts "Seeding data from #{file_name}..."

    sql = File.read(file_path)
    ActiveRecord::Base.connection.execute(sql)
    puts "#{file_name} seeded successfully."
  else
    puts "File #{file_name} does not exist. Skipping."
  end

  progressbar.increment
end

def attach_file_to_record(record, attachment_name, file_path)
  if File.exist?(file_path)
    record.send(attachment_name).attach(
      io: File.open(file_path),
      filename: File.basename(file_path)
    )
  else
    puts "File #{file_path} does not exist. Skipping attachment for record #{record.id}."
  end
end

albums_metadata_path = Rails.root.join("db/seeds/music/albums/image_metadata.json")
if File.exist?(albums_metadata_path)
  albums_metadata = File.readlines(albums_metadata_path)
  progressbar = ProgressBar.create(total: albums_metadata.size)

  albums_metadata.each do |line|
    metadata = JSON.parse(line)
    album = Album.find(metadata["record_id"])
    file_path = Rails.root.join("db/seeds/music/albums", metadata["file_name"])
    attach_file_to_record(album, metadata["attachment_name"], file_path)
    progressbar.increment
  end
else
  puts "Album metadata file not found. Skipping album art."
end

people_metadata_path = Rails.root.join("db/seeds/music/people/image_metadata.json")
if File.exist?(people_metadata_path)
  people_metadata = File.readlines(people_metadata_path)
  progressbar = ProgressBar.create(total: people_metadata.size)

  people_metadata.each do |line|
    metadata = JSON.parse(line)
    person = Person.find(metadata["record_id"])
    file_path = Rails.root.join("db/seeds/music/people", metadata["file_name"])
    attach_file_to_record(person, metadata["attachment_name"], file_path)
    progressbar.increment
  end
else
  puts "People metadata file not found. Skipping person images."
end

orchestras_metadata_path = Rails.root.join("db/seeds/music/orchestras/image_metadata.json")
if File.exist?(orchestras_metadata_path)
  orchestras_metadata = File.readlines(orchestras_metadata_path)
  progressbar = ProgressBar.create(total: orchestras_metadata.size)

  orchestras_metadata.each do |line|
    metadata = JSON.parse(line)
    orchestra = Orchestra.find(metadata["record_id"])
    file_path = Rails.root.join("db/seeds/music/orchestras", metadata["file_name"])
    attach_file_to_record(orchestra, metadata["attachment_name"], file_path)
    progressbar.increment
  end
else
  puts "Orchestra metadata file not found. Skipping orchestra images."
end

waveforms_metadata_path = Rails.root.join("db/seeds/music/waveforms/image_metadata.json")
if File.exist?(waveforms_metadata_path)
  waveforms_metadata = File.readlines(waveforms_metadata_path)
  progressbar = ProgressBar.create(total: waveforms_metadata.size)

  waveforms_metadata.each do |line|
    metadata = JSON.parse(line)
    waveform = Waveform.find(metadata["record_id"])
    file_path = Rails.root.join("db/seeds/music/waveforms", metadata["file_name"])
    attach_file_to_record(waveform, metadata["attachment_name"], file_path)
    progressbar.increment
  end
else
  puts "Waveform metadata file not found. Skipping waveform images."
end

audio_file_path = Rails.root.join("spec/fixtures/files/audio/compressed/19401008_volver_a_sonar_roberto_rufino_tango_2476.mp3")

if File.exist?(audio_file_path)
  progressbar = ProgressBar.create(total: AudioFile.size)

  AudioFile.find_each do |audio_file|
    attach_file_to_record(audio_file, :file, audio_file_path)
    progressbar.increment
  end

  progressbar = ProgressBar.create(total: AudioVariant.size)

  AudioVariant.find_each do |audio_variant|
    attach_file_to_record(audio_variant, :audio_file, audio_file_path)
    progressbar.increment
  end
else
  puts "MP3 file #{audio_file_path} does not exist. Skipping attachment."
end

puts "Music data seeded successfully."
