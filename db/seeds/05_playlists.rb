def create_playlists_for_user(user)
  playlist_data = {
    "darienzo_essentials.m3u8" => "juan_d_arienzo.jpeg",
    "disarli_essentials.m3u8" => "carlos_di_sarli.jpeg",
    "dogac_la_coqueta.m3u8" => "dogac_ozen.jpeg",
    "dogac_petit_marathon.m3u8" => "dogac_ozen.jpeg",
    "pugliese_essentials.m3u8" => "osvaldo_pugliese.jpeg",
    "troilo_essentials.m3u8" => "anibal_troilo.jpeg"
  }

  base_path = Rails.root.join("db/seeds/playlists")

  playlist_data.each do |playlist_filename, image_filename|
    playlist_title = File.basename(playlist_filename, ".m3u8").humanize

    playlist = Playlist.find_or_create_by!(title: playlist_title) do |playlist|
      playlist.description = Faker::Lorem.sentence
      playlist.public = true
      playlist.user = user
    end

    attach_playlist_file(playlist, base_path.join(playlist_filename))
    attach_playlist_image(playlist, base_path.join(image_filename))
    Import::Playlist::PlaylistImporter.new(playlist).import
  end
end

def attach_playlist_file(playlist, file_path)
  playlist.playlist_file.attach(
    io: File.open(file_path),
    filename: File.basename(file_path),
    content_type: "application/vnd.apple.mpegurl"
  )
end

def attach_playlist_image(playlist, image_path)
  playlist.image.attach(
    io: File.open(image_path),
    filename: File.basename(image_path),
    content_type: "image/jpeg" # assuming JPEG format, adjust if needed
  )
end

normal_user = User.find_by(email: "user@tangocloud.app")

create_playlists_for_user(normal_user) if normal_user
