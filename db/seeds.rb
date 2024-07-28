require "csv"

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

# records = []

# CSV.parse(File.read(Rails.root.join("spec/fixtures/files/el_recodo_songs.csv")),
#   headers: true, quote_char: '"', col_sep: ";", liberal_parsing: true) do |row|
#   records << {
#     id: row["id"].presence || "",
#     date: row["date"].presence || "",
#     ert_number: row["ert_number"].presence || "",
#     title: row["title"].presence || "",
#     style: row["style"].presence || "",
#     label: row["label"].presence || "",
#     lyrics: row["lyrics"].presence || "",
#     search_data: row["search_data"].presence || "",
#     synced_at: row["synced_at"].presence || "",
#     page_updated_at: row["page_updated_at"].presence || "",
#     created_at: row["created_at"].presence || "",
#     updated_at: row["updated_at"].presence || ""
#   }
# end

# ElRecodoSong.insert_all(records)

# Import::DirectoryImporter.new(Rails.root.join("spec/fixtures/files/audio/")).sync(async: false)

# # Attach images to orchestras if they exist
# orchestra_name = row["orchestra"]
# if orchestra_name.present?
#   orchestra = Orchestra.find_by(name: orchestra_name)
#   if orchestra && !orchestra.photo.attached?
#     orchestra_image_path = Rails.root.join("spec/fixtures/files/orchestras/#{orchestra_name.parameterize}.jpg")
#     orchestra.photo.attach(io: File.open(orchestra_image_path), filename: "#{orchestra_name.parameterize}.jpg", content_type: "image/jpeg")
#   end
# end

# # Attach images to composers if they exist
# composer_name = row["composer"]
# if composer_name.present?
#   composer = Person.find_by(name: composer_name)
#   if composer && !composer.photo.attached?
#     composer_image_path = Rails.root.join("spec/fixtures/files/composers/#{composer_name.parameterize}.jpg")
#     composer.photo.attach(io: File.open(composer_image_path), filename: "#{composer_name.parameterize}.jpg", content_type: "image/jpeg")
#   end
# end

# # Attach images to lyricists if they exist
# author_name = row["author"]
# if author_name.present?
#   lyricist = Person.find_by(name: author_name)
#   if lyricist && !lyricist.photo.attached?
#     lyricist_image_path = Rails.root.join("spec/fixtures/files/lyricists/#{author_name.parameterize}.jpg")
#     lyricist.photo.attach(io: File.open(lyricist_image_path), filename: "#{author_name.parameterize}.jpg", content_type: "image/jpeg")
#   end
# end

# # Attach images to lyricists if they exist
# singer_name = row["singer"]
# if singer_name.present?
#   lyricist = Person.find_by(name: singer_name)
#   if lyricist && !lyricist.photo.attached?
#     lyricist_image_path = Rails.root.join("spec/fixtures/files/lyricists/#{singer_name.parameterize}.jpg")
#     lyricist.photo.attach(io: File.open(lyricist_image_path), filename: "#{singer_name.parameterize}.jpg", content_type: "image/jpeg")
#   end
# end

playlists = ["Morning Tango", "Evening Milonga", "Night Vals"].map do |title|
  Playlist.find_or_create_by!(title:) do |playlist|
    playlist.description = Faker::Lorem.sentence
    playlist.public = true
    playlist.user = normal_user
  end
end

# Attach recordings to playlists
recordings = Recording.all.sample(10)
playlists.each do |playlist|
  recordings.each_with_index do |recording, index|
    PlaylistItem.find_or_create_by!(playlist:, item: recording) do |item|
      item.position = index + 1
    end
  end
end

# Create likes
playlists.each do |playlist|
  Like.find_or_create_by!(likeable: playlist, user: normal_user)
end

# Reindexing models
ExternalCatalog::ElRecodo::Song.reindex
Recording.reindex
Playlist.reindex
Person.reindex
Genre.reindex
Orchestra.reindex
User.reindex

puts "Seed data created successfully!"
