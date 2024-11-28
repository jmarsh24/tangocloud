def process_playlists_for_user(user, directory, import_as_tandas:, playlist_type_name:)
  playlist_type = PlaylistType.find_or_create_by!(name: playlist_type_name)

  Dir.glob(File.join(directory, "*.m3u8")).each do |playlist_file_path|
    playlist_filename = File.basename(playlist_file_path)
    playlist_title = File.basename(playlist_filename, ".m3u8").humanize

    playlist = Playlist.find_or_create_by!(title: playlist_title) do |new_playlist|
      new_playlist.description = Faker::Lorem.sentence
      new_playlist.public = true
      new_playlist.user = user
      new_playlist.import_as_tandas = import_as_tandas
      new_playlist.playlist_type = playlist_type
    end

    attach_playlist_file(playlist, playlist_file_path)

    Import::Playlist::PlaylistImporter.new(playlist).import

    playlist.attach_default_image
  end
end

def attach_playlist_file(playlist, file_path)
  playlist.playlist_file.attach(
    io: File.open(file_path),
    filename: File.basename(file_path),
    content_type: "application/vnd.apple.mpegurl"
  )
end

normal_user = User.find_by(email: "user@tangocloud.app")

# Process DJ Sets
dj_sets_path = Rails.root.join("db/seeds/common/playlists/dj_sets")
process_playlists_for_user(normal_user, dj_sets_path, import_as_tandas: false, playlist_type_name: "DJ Set")

# Process Essentials
essentials_path = Rails.root.join("db/seeds/common/playlists/essentials")
process_playlists_for_user(normal_user, essentials_path, import_as_tandas: false, playlist_type_name: "Essential")

# Process Liked Recordings
liked_recordings_path = Rails.root.join("db/seeds/common/playlists/liked_recordings")
process_playlists_for_user(normal_user, liked_recordings_path, import_as_tandas: false, playlist_type_name: "Best Of")

# Create Mood Playlists
playlist_type = PlaylistType.find_or_create_by!(name: "Mood")

mood_mapping = {
  "Energetic" => ["juan-d-arienzo"],
  "Romantic" => ["carlos-di-sarli", "osvaldo-fresedo", "pedro-laurenz", "domingo-federico", "lucio-demare"],
  "Drama" => ["osvaldo-pugliese", "alfredo-gobbi", "anibal-troilo", "roberto-goyeneche", "julio-de-caro"],
  "Calm" => ["miguel-calo", "jose-garcia", "domingo-federico"],
  "Nostalgic" => ["angel-d-agostino", "francisco-canaro"],
  "Playful" => ["orquesta-tipica-victor", "rodolfo-biagi", "francisco-canaro"]
}

mood_mapping.each do |mood, orchestras|
  playlist = Playlist.create!(title: mood, playlist_type: playlist_type)

  recordings = Recording.joins(:orchestra)
    .where(orchestra: {slug: orchestras})
    .order(popularity_score: :desc)
    .limit(100)

  recordings.each_with_index do |recording, index|
    PlaylistItem.create!(playlist: playlist, item: recording, position: index + 1)
  end
end

puts "Mood playlists created successfully!"
puts "Playlists have been successfully imported!"
