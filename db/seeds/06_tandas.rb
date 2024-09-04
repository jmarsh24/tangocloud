def create_tandas_for_user(user)
  tanda_data = {
    "Biagi, Rodolfo - Tanda 9.m3u8" => "biagi_rodolfo.jpeg",
    "Biagi, Rodolfo - Tanda 15.m3u8" => "biagi_rodolfo.jpeg",
    "Biagi, Rodolfo - Tanda 18.m3u8" => "biagi_rodolfo.jpeg",
    "Caló, Miguel - Tanda 19.m3u8" => "calo_miguel.jpeg",
    "Canaro, Francisco - Tanda 6.m3u8" => "canaro_francisco.jpeg",
    "D’Agostino, Ángel - Tanda 21.m3u8" => "dagostino_angel.jpeg",
    "D’Arienzo, Juan - Tanda 4.m3u8" => "darienzo_juan.jpeg",
    "D’Arienzo, Juan - Tanda 13.m3u8" => "darienzo_juan.jpeg",
    "D’Arienzo, Juan - Tanda 20.m3u8" => "darienzo_juan.jpeg",
    "De Angelis, Alfredo - Tanda 22.m3u8" => "de_angelis_alfredo.jpeg",
    "Di Sarli (Sexteto) - Tanda 1.m3u8" => "di_sarli_carlos.jpeg",
    "Di Sarli, Carlos - Tanda 2.m3u8" => "di_sarli_carlos.jpeg",
    "Di Sarli, Carlos - Tanda 16.m3u8" => "di_sarli_carlos.jpeg",
    "Di Sarli, Carlos - Tanda 23.m3u8" => "di_sarli_carlos.jpeg",
    "Donato, Edgardo - Tanda 24.m3u8" => "donato_edgardo.jpeg",
    "Fresedo, Osvaldo - Tanda 26.m3u8" => "fresedo_osvaldo.jpeg",
    "Laurenz, Pedro - Tanda 7.m3u8" => "laurenz_pedro.jpeg",
    "Laurenz, Pedro - Tanda 27.m3u8" => "laurenz_pedro.jpeg",
    "Lomuto, Francisco - Tanda 28.m3u8" => "lomuto_francisco.jpeg",
    "Pugliese, Osvaldo - Tanda 8.m3u8" => "osvaldo_pugliese.jpeg",
    "Pugliese, Osvaldo - Tanda 12.m3u8" => "osvaldo_pugliese.jpeg",
    "Pugliese, Osvaldo - Tanda 29.m3u8" => "osvaldo_pugliese.jpeg",
    "Rodríguez, Enrique - Tanda 3.m3u8" => "rodriguez_enrique.jpeg",
    "Rodríguez, Enrique - Tanda 30.m3u8" => "rodriguez_enrique.jpeg",
    "Salamanca, Fulvio - Tanda 31.m3u8" => "salamanca_fulvio.jpeg",
    "Tanturi, Ricardo - Tanda 10.m3u8" => "tanturi_ricardo.jpeg",
    "Tanturi, Ricardo - Tanda 32.m3u8" => "tanturi_ricardo.jpeg",
    "Troilo, Aníbal - Tanda 5.m3u8" => "troilo_anibal.jpeg",
    "Troilo, Aníbal - Tanda 11.m3u8" => "troilo_anibal.jpeg",
    "Troilo, Aníbal - Tanda 14.m3u8" => "troilo_anibal.jpeg",
    "Troilo, Aníbal - Tanda 33.m3u8" => "troilo_anibal.jpeg"
  }

  base_path = Rails.root.join("db/seeds/tandas")

  tanda_data.each do |tanda_filename, image_filename|
    tanda_title = File.basename(tanda_filename, ".m3u8").humanize

    tanda = Tanda.find_or_initialize_by(title: tanda_title, user:) do |tanda|
      tanda.description = Faker::Lorem.sentence
      tanda.public = true
    end

    recordings = Import::Playlist::AudioFileMatcher.new(base_path.join(tanda_filename)).recordings

    position = 1
    recordings.each do |recording|
      tanda.playlist_items.build(item: recording, position:)
      position += 1
    end

    tanda.save!

    attach_tanda_file(tanda, base_path.join(tanda_filename))
    attach_tanda_image(tanda, base_path.join(image_filename))
  end
end

def attach_tanda_file(tanda, file_path)
  tanda.playlist_file.attach(
    io: File.open(file_path),
    filename: File.basename(file_path),
    content_type: "application/vnd.apple.mpegurl"
  )
end

def attach_tanda_image(tanda, image_path)
  tanda.image.attach(
    io: File.open(image_path),
    filename: File.basename(image_path),
    content_type: "image/jpeg"
  )
end

normal_user = User.find_by(email: "admin@tangocloud.app")
create_tandas_for_user(normal_user) if normal_user
