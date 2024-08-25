# puts "Seeding music data..."

# sql_files = [
#   "audio_files.sql",
#   "people.sql",
#   "compositions.sql",
#   "languages.sql",
#   "lyrics.sql",
#   "composition_lyrics.sql",
#   "composition_roles.sql",
#   "orchestras.sql",
#   "orchestra_roles.sql",
#   "orchestra_positions.sql",
#   "record_labels.sql",
#   "genres.sql",
#   "recordings.sql",
#   "recording_singers.sql",
#   "albums.sql",
#   "remaster_agents.sql",
#   "digital_remasters.sql",
#   "audio_variants.sql",
#   "waveform_data.sql",
#   "waveforms.sql"
# ]

# puts "Seeding SQL files..."

# progress_bar = ProgressBar.new(sql_files.size)

# sql_files.each do |file_name|
#   file_path = Rails.root.join("db/seeds/music", file_name)

#   if File.exist?(file_path)
#     puts "Seeding data from #{file_name}..."

#     sql = File.read(file_path)
#     ActiveRecord::Base.connection.execute(sql)
#     puts "#{file_name} seeded successfully."
#   else
#     puts "File #{file_name} does not exist. Skipping."
#   end

#   progress_bar.increment!
# end

# def attach_file_to_record(record, attachment_name, file_path)
#   if File.exist?(file_path)
#     record.send(attachment_name).attach(
#       io: File.open(file_path),
#       filename: File.basename(file_path)
#     )
#   else
#     puts "File #{file_path} does not exist. Skipping attachment for record #{record.id}."
#   end
# end

# albums_metadata_path = Rails.root.join("db/seeds/music/albums/album_art_metadata.json")
# raise "Album metadata file not found" unless File.exist?(albums_metadata_path)

# if File.exist?(albums_metadata_path)
#   albums_metadata = File.readlines(albums_metadata_path)
#   progress_bar = ProgressBar.new(albums_metadata.size)

#   albums_metadata.each do |line|
#     metadata = JSON.parse(line)
#     album = Album.find(metadata["record_id"])
#     file_path = Rails.root.join("db/seeds/music/albums", metadata["file_name"])
#     attach_file_to_record(album, metadata["attachment_name"], file_path)
#     progress_bar.increment!
#   end
# else
#   puts "Album metadata file not found. Skipping album art."
# end

# people_metadata_path = Rails.root.join("db/seeds/music/people/image_metadata.json")
# if File.exist?(people_metadata_path)
#   people_metadata = File.readlines(people_metadata_path)
#   progress_bar = ProgressBar.new(people_metadata.size)

#   people_metadata.each do |line|
#     metadata = JSON.parse(line)
#     person = Person.find(metadata["record_id"])
#     file_path = Rails.root.join("db/seeds/music/people", metadata["file_name"])
#     attach_file_to_record(person, metadata["attachment_name"], file_path)
#     progress_bar.increment!
#   end
# else
#   puts "People metadata file not found. Skipping person images."
# end

# orchestras_metadata_path = Rails.root.join("db/seeds/music/orchestras/image_metadata.json")
# if File.exist?(orchestras_metadata_path)
#   orchestras_metadata = File.readlines(orchestras_metadata_path)
#   progress_bar = ProgressBar.new(orchestras_metadata.size)

#   orchestras_metadata.each do |line|
#     metadata = JSON.parse(line)
#     orchestra = Orchestra.find(metadata["record_id"])
#     file_path = Rails.root.join("db/seeds/music/orchestras", metadata["file_name"])
#     attach_file_to_record(orchestra, metadata["attachment_name"], file_path)
#     progress_bar.increment!
#   end
# else
#   puts "Orchestra metadata file not found. Skipping orchestra images."
# end

# waveforms_metadata_path = Rails.root.join("db/seeds/music/waveforms/image_metadata.json")
# if File.exist?(waveforms_metadata_path)
#   waveforms_metadata = File.readlines(waveforms_metadata_path)
#   progress_bar = ProgressBar.new(waveforms_metadata.size)

#   waveforms_metadata.each do |line|
#     metadata = JSON.parse(line)
#     waveform = Waveform.find(metadata["record_id"])
#     file_path = Rails.root.join("db/seeds/music/waveforms", metadata["file_name"])
#     attach_file_to_record(waveform, metadata["attachment_name"], file_path)
#     progress_bar.increment!
#   end
# else
#   puts "Waveform metadata file not found. Skipping waveform images."
# end
