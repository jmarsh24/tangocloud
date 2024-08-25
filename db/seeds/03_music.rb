puts "Seeding music data..."

sql_files = [
  "audio_files.sql",
  "people.sql",
  "compositions.sql",
  "languages.sql",
  "lyrics.sql",
  "composition_lyrics.sql",
  "composition_roles.sql",
  "orchestras.sql",
  "orchestra_roles.sql",
  "orchestra_positions.sql",
  "record_labels.sql",
  "genres.sql",
  "recordings.sql",
  "recording_singers.sql",
  "albums.sql",
  "remaster_agents.sql",
  "digital_remasters.sql",
  "audio_variants.sql",
  "waveform_data.sql",
  "waveforms.sql"
]

puts "Seeding SQL files..."

progress_bar = ProgressBar.new(sql_files.size)

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

  progress_bar.increment!
end

def create_blob_with_specific_id(metadata)
  blob = ActiveStorage::Blob.new(
    id: blob_id,
    key: blob_id, # Set key same as id if desired, or generate a new key
    filename: metadata["file_name"],
    content_type: metadata["metadata"]["content_type"],
    metadata: metadata["metadata"],
    byte_size: File.size(file_path),
    checksum: Digest::MD5.file(file_path).base64digest, # Calculate checksum
    service_name: ActiveStorage::Blob.service.name
  )

  # Save the blob record without uploading
  blob.save!

  # Upload the file to the service
  blob.upload(File.open(file_path))

  puts "Created blob with ID #{blob.id} for file #{metadata["file_name"]}."
  blob
end

def create_blobs_from_mapping(blob_mapping_path)
  if File.exist?(blob_mapping_path)
    blob_mappings = JSON.parse(File.read(blob_mapping_path))
    progress_bar = ProgressBar.new(blob_mappings.size)
    base_directory = File.dirname(blob_mapping_path)

    ActiveRecord::Base.transaction do
      blob_mappings.each do |blob_id, metadata|
        file_path = Rails.root.join(base_directory, metadata["file_name"])

        if File.exist?(file_path)
          create_blob_with_specific_id(blob_id, metadata, file_path)
        else
          puts "File #{file_path} does not exist. Skipping blob creation for #{blob_id}."
        end

        progress_bar.increment!
      end
    end
  else
    puts "Blob mapping file not found at #{blob_mapping_path}. Skipping."
  end
end

def process_attachment_metadata(metadata_path, model_class)
  if File.exist?(metadata_path)
    File.foreach(metadata_path) do |line|
      next if line.strip.empty? # Skip empty lines

      data = JSON.parse(line)
      record = model_class.find_by(id: data["record_id"])
      blob = ActiveStorage::Blob.find_by(id: data["blob_id"])

      if record && blob
        record.send(data["attachment_name"]).attach(blob)
        puts "Attached blob #{blob.id} to #{record.class.name} with ID #{record.id}."
      elsif record.nil?
        raise "Record with ID #{data["record_id"]} not found in #{model_class.name}. Skipping."
      else
        raise "Blob with ID #{data["blob_id"]} not found. Skipping attachment for #{model_class.name} with ID #{data["record_id"]}."
      end
    end
  else
    raise "Metadata file not found at #{metadata_path}. Skipping."
  end
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

albums_metadata_path = Rails.root.join("db/seeds/music/albums/album_art_metadata.json")
raise "Album metadata file not found" unless File.exist?(albums_metadata_path)

if File.exist?(albums_metadata_path)
  albums_metadata = File.readlines(albums_metadata_path)
  progress_bar = ProgressBar.new(albums_metadata.size)

  albums_metadata.each do |line|
    metadata = JSON.parse(line)
    album = Album.find(metadata["record_id"])
    file_path = Rails.root.join("db/seeds/music/albums", metadata["file_name"])
    attach_file_to_record(album, metadata["attachment_name"], file_path)
    progress_bar.increment!
  end
else
  puts "Album metadata file not found. Skipping album art."
end

people_metadata_path = Rails.root.join("db/seeds/music/people/image_metadata.json")
if File.exist?(people_metadata_path)
  people_metadata = File.readlines(people_metadata_path)
  progress_bar = ProgressBar.new(people_metadata.size)

  people_metadata.each do |line|
    metadata = JSON.parse(line)
    person = Person.find(metadata["record_id"])
    file_path = Rails.root.join("db/seeds/music/people", metadata["file_name"])
    attach_file_to_record(person, metadata["attachment_name"], file_path)
    progress_bar.increment!
  end
else
  puts "People metadata file not found. Skipping person images."
end

orchestras_metadata_path = Rails.root.join("db/seeds/music/orchestras/image_metadata.json")
if File.exist?(orchestras_metadata_path)
  orchestras_metadata = File.readlines(orchestras_metadata_path)
  progress_bar = ProgressBar.new(orchestras_metadata.size)

  orchestras_metadata.each do |line|
    metadata = JSON.parse(line)
    orchestra = Orchestra.find(metadata["record_id"])
    file_path = Rails.root.join("db/seeds/music/orchestras", metadata["file_name"])
    attach_file_to_record(orchestra, metadata["attachment_name"], file_path)
    progress_bar.increment!
  end
else
  puts "Orchestra metadata file not found. Skipping orchestra images."
end

puts "Creating ActiveStorage blobs for waveforms..."
create_blobs_from_mapping(Rails.root.join("db/seeds/music/waveforms/image_blob_mapping.json"))

puts "Creating ActiveStorage blobs for audio variants..."
create_blobs_from_mapping(Rails.root.join("db/seeds/music/audio_variants/audio_file_blob_mapping.json"))

puts "Creating ActiveStorage blobs for audio files..."
create_blobs_from_mapping(Rails.root.join("db/seeds/music/audio_files/file_blob_mapping.json"))

puts "Processing audio variants..."
process_attachment_metadata(
  Rails.root.join("db/seeds/music/audio_variants/audio_file_metadata.json"),
  AudioVariant
)

puts "Processing audio files..."
process_attachment_metadata(
  Rails.root.join("db/seeds/music/audio_files/file_metadata.json"),
  AudioFile
)

puts "Processing waveform images..."
process_attachment_metadata(
  Rails.root.join("db/seeds/music/waveforms/image_metadata.json"),
  Waveform
)
