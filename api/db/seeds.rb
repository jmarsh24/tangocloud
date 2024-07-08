# Helper method to create a user
def create_user(email, password, admin = false)
  user = User.find_or_create_by!(email:) do |u|
    u.password = password
    u.admin = admin
    u.username = email.split("@").first
    u.verified = true
  end

  unless user.avatar.attached?
    user.avatar.attach(io: File.open(Rails.root.join("spec/fixtures/files/avatar.jpg")), filename: "avatar.jpg", content_type: "image/jpeg")
  end

  user
end

# Create users
create_user("admin@tangocloud.app", "tangocloud123", true)
normal_user = create_user("user@tangocloud.app", "tangocloud123")

# Create genres
genres = ["Tango", "Vals", "Milonga"].map do |name|
  Genre.find_or_create_by!(name:) do |genre|
    genre.description = Faker::Lorem.sentence
  end
end

# Create orchestras (use name for orchestras as is)
orchestras = [
  "Carlos Di Sarli",
  "Juan D'Arienzo",
  "Osvaldo Pugliese"
].map do |name|
  Orchestra.find_or_create_by!(name:) do |orchestra|
    unless orchestra.photo.attached?
      orchestra.photo.attach(io: File.open(Rails.root.join("spec/fixtures/files/di_sarli.jpg")), filename: "orchestra.jpg", content_type: "image/jpeg")
    end
  end
end

# Create composers
composers = [
  "Carlos Gardel",
  "Astor Piazzolla",
  "Anibal Troilo"
].map do |name|
  Person.find_or_create_by!(name:) do |composer|
    unless composer.photo.attached?
      composer.photo.attach(io: File.open(Rails.root.join("spec/fixtures/files/di_sarli.jpg")), filename: "composer.jpg", content_type: "image/jpeg")
    end
  end
end

# Create lyricists
lyricists = [
  "Alfredo Le Pera",
  "Homero Manzi",
  "Enrique Santos Discepolo"
].map do |name|
  Person.find_or_create_by!(name:) do |lyricist|
    unless lyricist.photo.attached?
      lyricist.photo.attach(io: File.open(Rails.root.join("spec/fixtures/files/di_sarli.jpg")), filename: "lyricist.jpg", content_type: "image/jpeg")
    end
  end
end

# Create albums
albums = ["Best of Tango", "Tango Classics", "Golden Age of Tango"].map do |title|
  Album.find_or_create_by!(title:) do |album|
    album.description = Faker::Lorem.paragraph
    album.release_date = Faker::Date.between(from: "1930-01-01", to: "1950-12-31")
    unless album.album_art.attached?
      album.album_art.attach(io: File.open(Rails.root.join("spec/fixtures/files/album-art-volver-a-sonar.jpg")), filename: "album_art.jpg", content_type: "image/jpeg")
    end
  end
end

# Create compositions
compositions = ["Libertango", "Adiós Nonino", "Oblivion"].map do |title|
  Composition.find_or_create_by!(title:) do |composition|
    composition.composers << composers.sample
    composition.lyricists << lyricists.sample
  end
end

# Create singers
singers = [
  "Roberto Rufino",
  "Alberto Podestá",
  "Carlos Gardel"
].map do |name|
  Person.find_or_create_by!(name:) do |singer|
    unless singer.photo.attached?
      singer.photo.attach(io: File.open(Rails.root.join("spec/fixtures/files/di_sarli.jpg")), filename: "singer.jpg", content_type: "image/jpeg")
    end
  end
end

# Create recordings
recordings = compositions.map do |composition|
  Recording.find_or_create_by!(composition:) do |recording|
    recording.recording_type = "studio"
    recording.recorded_date = Faker::Date.between(from: "1930-01-01", to: "1950-12-31")
    recording.genre = genres.sample
    recording.orchestra = orchestras.sample
    recording.singers = singers.sample(2)
  end
end

# Create audio files
audio_files = Dir[Rails.root.join("spec/fixtures/files/audio/*.mp3")].map do |audio_file_path|
  filename = File.basename(audio_file_path)
  AudioFile.find_or_create_by!(filename:, format: "audio/mp3") do |audio_file|
    audio_file.file.attach(io: File.open(audio_file_path), filename:, content_type: "audio/mpeg")
  end
end

# Create digital remasters
digital_remasters = recordings.map do |recording|
  DigitalRemaster.find_or_create_by!(recording:) do |digital_remaster|
    digital_remaster.external_id = Faker::Number.unique.number(digits: 8).to_s
    digital_remaster.album = albums.sample
    digital_remaster.remaster_agent = RemasterAgent.find_or_create_by!(name: Faker::Name.name) do |agent|
      agent.description = Faker::Lorem.sentence
    end
    digital_remaster.audio_file = audio_files.sample
  end
end

# Create audio variants
digital_remasters.each do |digital_remaster|
  AudioVariant.find_or_create_by!(digital_remaster:) do |audio_variant|
    audio_variant.format = "mp3"
    audio_variant.bit_rate = 128
    audio_variant.digital_remaster = digital_remaster
  end
end

# Create playlists
playlists = ["Morning Tango", "Evening Milonga", "Night Vals"].map do |title|
  Playlist.find_or_create_by!(title:) do |playlist|
    playlist.description = Faker::Lorem.sentence
    playlist.public = true
    playlist.user = normal_user
  end
end

# Create playlist items
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

# Create el_recodo_songs
["El Día Que Me Quieras", "Mi Buenos Aires Querido", "Volver"].map do |title|
  ExternalCatalog::ElRecodoSong.find_or_create_by!(title:) do |song|
    song.date = Faker::Date.between(from: "1930-01-01", to: "1950-12-31")
    song.ert_number = Faker::Number.unique.number(digits: 5)
    song.music_id = Faker::Number.unique.number(digits: 5)
    song.orchestra = orchestras.sample.name
    song.composer = composers.sample.name
    song.author = lyricists.sample.name
    song.page_updated_at = Faker::Date.between(from: "2020-01-01", to: "2021-12-31")
  end
end

# Create waveforms
digital_remasters.each do |digital_remaster|
  waveform_filepath = Rails.root.join("spec/fixtures/files/waveform_data_volver_a_sonar.json")
  data = JSON.parse(File.read(waveform_filepath))
  Waveform.find_or_create_by!(digital_remaster:) do |waveform|
    waveform.version = 1
    waveform.channels = 2
    waveform.sample_rate = 44100
    waveform.samples_per_pixel = 256
    waveform.bits = 16
    waveform.length = 300000
    waveform.data = data
    unless waveform.image.attached?
      waveform.image.attach(io: File.open(Rails.root.join("spec/fixtures/files/19401008_volver_a_sonar_roberto_rufino_tango_2476_waveform.png")), filename: "waveform.png", content_type: "image/png")
    end
  end
end

# Reindexing models
ExternalCatalog::ElRecodoSong.reindex
Recording.reindex
Playlist.reindex
Person.reindex
Genre.reindex
Orchestra.reindex
User.reindex

puts "Seed data created successfully!"
