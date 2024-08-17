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
  file_path = Rails.root.join("db/seeds/el_recodo", file_name)

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
