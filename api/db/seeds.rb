# Helper method to create a user
def create_user(email, password, admin = false)
  user = User.create!(
    email:,
    password:,
    admin:,
    username: email.split("@").first,
    verified: true
  )

  user.avatar.attach(io: File.open(Rails.root.join("spec/fixtures/files/avatar.jpg")), filename: "avatar.jpg", content_type: "image/jpeg")
  user
end

# Create users
create_user("admin@example.com", "tangocloud123", true)
normal_user = create_user("user@example.com", "tangocloud123")

# Create genres
genres = ["Tango", "Vals", "Milonga"].map do |name|
  Genre.create!(name:, description: Faker::Lorem.sentence)
end

# Create orchestras (use name for orchestras as is)
orchestras = [
  {first_name: "Carlos", last_name: "Di Sarli"},
  {first_name: "Juan", last_name: "D'Arienzo"},
  {first_name: "Osvaldo", last_name: "Pugliese"}
].map do |attrs|
  orchestra = Orchestra.create!(attrs)
  orchestra.photo.attach(io: File.open(Rails.root.join("spec/fixtures/files/di_sarli.jpg")), filename: "orchestra.jpg", content_type: "image/jpeg")
  orchestra
end

# Create composers
composers = [
  {first_name: "Carlos", last_name: "Gardel"},
  {first_name: "Astor", last_name: "Piazzolla"},
  {first_name: "Anibal", last_name: "Troilo"}
].map do |attrs|
  composer = Composer.create!(attrs)
  composer.photo.attach(io: File.open(Rails.root.join("spec/fixtures/files/di_sarli.jpg")), filename: "composer.jpg", content_type: "image/jpeg")
  composer
end

# Create lyricists
lyricists = [
  {first_name: "Alfredo", last_name: "Le Pera"},
  {first_name: "Homero", last_name: "Manzi"},
  {first_name: "Enrique Santos", last_name: "Discepolo"}
].map do |attrs|
  lyricist = Lyricist.create!(attrs)
  lyricist.photo.attach(io: File.open(Rails.root.join("spec/fixtures/files/di_sarli.jpg")), filename: "lyricist.jpg", content_type: "image/jpeg")
  lyricist
end

# Create albums
albums = ["Best of Tango", "Tango Classics", "Golden Age of Tango"].map do |title|
  album = Album.create!(
    title:,
    description: Faker::Lorem.paragraph,
    release_date: Faker::Date.between(from: "1930-01-01", to: "1950-12-31"),
    album_type: "compilation"
  )
  album.album_art.attach(io: File.open(Rails.root.join("spec/fixtures/files/album-art-volver-a-sonar.jpg")), filename: "album_art.jpg", content_type: "image/jpeg")
  album
end

# Create compositions
compositions = ["Libertango", "Adiós Nonino", "Oblivion"].map do |title|
  Composition.create!(
    title:,
    composer: composers.sample,
    lyricist: lyricists.sample
  )
end

# Create recordings
recordings = ["La Cumparsita", "El Choclo", "A Media Luz"].map do |title|
  Recording.create!(
    title:,
    recording_type: "studio",
    release_date: Faker::Date.between(from: "1930-01-01", to: "1950-12-31"),
    genre: genres.sample,
    orchestra: orchestras.sample,
    composition: compositions.sample,
    recorded_date: Faker::Date.between(from: "1930-01-01", to: "1950-12-31")
  )
end

# Create audio transfers
audio_transfers = recordings.map do |recording|
  audio_transfer = AudioTransfer.create!(
    external_id: Faker::Number.unique.number(digits: 8).to_s,
    position: Faker::Number.between(from: 1, to: 10),
    album: albums.sample,
    recording:,
    filename: "#{recording.title.parameterize}.mp3",
    transfer_agent: TransferAgent.create!(name: Faker::Name.name, description: Faker::Lorem.sentence)
  )
  audio_transfer.audio_file.attach(io: File.open(Rails.root.join("spec/fixtures/audio/19401008_volver_a_sonar_roberto_rufino_tango_2476.flac")), filename: "audio_file.flac", content_type: "audio/flac")
  audio_transfer
end

# Create audio variants
audio_transfers = audio_transfers.map do |audio_transfer|
  audio_variant = AudioVariant.create!(
    audio_transfer:,
    duration: Faker::Number.between(from: 120, to: 360),
    format: "mp3",
    codec: "libmp3lame",
    bit_rate: 128,
    sample_rate: 44100,
    channels: 2,
    metadata: {},
    filename: "#{audio_transfer.filename}_variant.mp3"
  )
  audio_variant.audio_file.attach(io: File.open(Rails.root.join("spec/fixtures/audio/19421009_no_te_apures_carablanca_juan_carlos_miranda_tango_1918.m4a")), filename: "audio_file.m4a", content_type: "audio/m4a")
  audio_transfer
end

# Create playlists
playlists = ["Morning Tango", "Evening Milonga", "Night Vals"].map do |title|
  Playlist.create!(
    title:,
    description: Faker::Lorem.sentence,
    public: true,
    user: normal_user
  )
end

# Create playlist items
playlists.each do |playlist|
  recordings.each_with_index do |recording, index|
    PlaylistItem.create!(
      playlist:,
      playable: recording,
      position: index + 1
    )
  end
end

# Create likes
playlists.each do |playlist|
  Like.create!(likeable: playlist, user: normal_user)
end

# Create el_recodo_songs
el_recodo_songs = ["El Día Que Me Quieras", "Mi Buenos Aires Querido", "Volver"].map do |title|
  ElRecodoSong.create!(
    title:,
    date: Faker::Date.between(from: "1930-01-01", to: "1950-12-31"),
    ert_number: Faker::Number.unique.number(digits: 5),
    music_id: Faker::Number.unique.number(digits: 5),
    orchestra: orchestras.sample.name,
    composer: composers.sample.name,
    author: lyricists.sample.name,
    page_updated_at: Faker::Date.between(from: "2020-01-01", to: "2021-12-31")
  )
end

# Create sessions
sessions = ["Morning Practice", "Evening Rehearsal", "Night Performance"].map do |name|
  Session.create!(
    user: normal_user,
    user_agent: Faker::Internet.user_agent,
    ip_address: Faker::Internet.ip_v4_address
  )
end

# Create waveforms
waveforms = audio_transfers.map do |audio_transfer|
  waveform_filepath = Rails.root.join("spec/fixtures/files/waveform_data_volver_a_sonar.json")
  data = JSON.parse(File.read(waveform_filepath))
  waveform = Waveform.create!(
    audio_transfer:,
    version: 1,
    channels: 2,
    sample_rate: 44100,
    samples_per_pixel: 256,
    bits: 16,
    length: 300000,
    data:
  )
  waveform.image.attach(io: File.open(Rails.root.join("spec/fixtures/files/19401008_volver_a_sonar_roberto_rufino_tango_2476_waveform.png")), filename: "waveform.png", content_type: "image/png")
  waveform
end

ElRecodoSong.reindex
Recording.reindex
Playlist.reindex
Composer.reindex
Genre.reindex
Lyricist.reindex
Orchestra.reindex
Period.reindex
Singer.reindex
User.reindex

puts "Seed data created successfully!"
