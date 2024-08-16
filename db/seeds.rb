def create_user(email, password, admin = false)
  user = User.find_or_create_by!(email:) do |u|
    u.password = password
    u.admin = admin
    u.username = email.split("@").first
  end

  unless user.avatar.attached?
    user.avatar.attach(io: File.open(Rails.root.join("spec/fixtures/files/avatar.jpg")), filename: "avatar.jpg", content_type: "image/jpeg")
  end

  user
end

# Create users
create_user("admin@tangocloud.app", "tangocloud123", true)
normal_user = create_user("user@tangocloud.app", "tangocloud123")

["Tango", "Vals", "Milonga"].map do |name|
  Genre.find_or_create_by!(name:)
end

# Step 1: Seed the SQL Files
sql_files = [
  "external_catalog_el_recodo_empty_pages.sql",
  "external_catalog_el_recodo_orchestras.sql",
  "external_catalog_el_recodo_people.sql",
  "external_catalog_el_recodo_songs.sql",
  "external_catalog_el_recodo_person_roles.sql"
]

puts "Seeding SQL files..."
progressbar = ProgressBar.create(total: sql_files.size)

sql_files.each do |file_name|
  file_path = Rails.root.join("db/seeds", file_name)

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

# Step 2: Attach the Images
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

# Attach images for people
people_metadata_path = Rails.root.join("db/seeds/images/el_recodo_people/image_metadata.json")
if File.exist?(people_metadata_path)
  people_metadata = File.readlines(people_metadata_path)
  progressbar = ProgressBar.create(total: people_metadata.size)

  people_metadata.each do |line|
    metadata = JSON.parse(line)
    person = ExternalCatalog::ElRecodo::Person.find(metadata["record_id"])
    file_path = Rails.root.join("db/seeds/images/el_recodo_people", metadata["file_name"])
    attach_file_to_record(person, metadata["attachment_name"], file_path)
    progressbar.increment
  end
else
  puts "People metadata file not found. Skipping person images."
end

# Attach images for orchestras
orchestras_metadata_path = Rails.root.join("db/seeds/images/el_recodo_orchestras/image_metadata.json")
if File.exist?(orchestras_metadata_path)
  orchestras_metadata = File.readlines(orchestras_metadata_path)
  progressbar = ProgressBar.create(total: orchestras_metadata.size)

  orchestras_metadata.each do |line|
    metadata = JSON.parse(line)
    orchestra = ExternalCatalog::ElRecodo::Orchestra.find(metadata["record_id"])
    file_path = Rails.root.join("db/seeds/images/el_recodo_orchestras", metadata["file_name"])
    attach_file_to_record(orchestra, metadata["attachment_name"], file_path)
    progressbar.increment
  end
else
  puts "Orchestra metadata file not found. Skipping orchestra images."
end

puts "Seeding complete."

playlists = ["Morning Tango", "Evening Milonga", "Night Vals"].map do |title|
  Playlist.find_or_create_by!(title:) do |playlist|
    playlist.description = Faker::Lorem.sentence
    playlist.public = true
    playlist.user = normal_user
  end
end

recordings = Recording.all.sample(10)
playlists.each do |playlist|
  recordings.each_with_index do |recording, index|
    PlaylistItem.find_or_create_by!(playlist:, item: recording) do |item|
      item.position = index + 1
    end
  end
end

playlists.each do |playlist|
  Like.find_or_create_by!(likeable: playlist, user: normal_user)
end

puts "Reindexing models..."
models = [
  ExternalCatalog::ElRecodo::Song,
  Recording,
  Playlist,
  Person,
  Genre,
  Orchestra,
  User
]

progressbar = ProgressBar.create(total: models.size)

models.each do |model|
  model.reindex
  progressbar.increment
end
