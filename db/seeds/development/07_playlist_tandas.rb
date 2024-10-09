def attach_playlist_file(playlist, file_path)
  playlist.playlist_file.attach(
    io: File.open(file_path),
    filename: File.basename(file_path),
    content_type: "application/vnd.apple.mpegurl"
  )
end

def attach_playlist_image(tanda, image_path)
  tanda.image.attach(
    io: File.open(image_path),
    filename: File.basename(image_path),
    content_type: "image/jpeg"
  )
end

user = User.find_by!(email: "admin@tangocloud.app")

playlist = Playlist.create!(title: "La Coqueta 2024", user:, subtitle: "Lyon, France")

Tanda.limit(12).each_with_index do |tanda, index|
  playlist.playlist_items.create!(item: tanda, position: index)
  attach_playlist_image(playlist, Rails.root.join("db/seeds/development/playlists/dogac_ozen.jpeg"))
  attach_playlist_file(playlist, Rails.root.join("db/seeds/development/playlists/dogac_la_coqueta.m3u8"))
end

playlist = Playlist.create!(title: "Petit Marathon", user:, subtitle: "Lyon, France")

Tanda.offset(12).limit(17).each_with_index do |tanda, index|
  playlist.playlist_items.create!(item: tanda, position: index)
  attach_playlist_image(playlist, Rails.root.join("db/seeds/development/playlists/dogac_ozen.jpeg"))
  attach_playlist_file(playlist, Rails.root.join("db/seeds/development/playlists/dogac_petit_marathon.m3u8"))
end
