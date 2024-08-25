# def create_playlists_for_user(user)
#   playlist_titles = ["Morning Tango", "Evening Milonga", "Night Vals"]

#   playlists = playlist_titles.map do |title|
#     Playlist.find_or_create_by!(title:) do |playlist|
#       playlist.description = Faker::Lorem.sentence
#       playlist.public = true
#       playlist.user = user
#     end
#   end

#   add_recordings_to_playlists(playlists)
#   like_playlists(playlists, user)
# end

# def add_recordings_to_playlists(playlists)
#   recordings = Recording.all.sample(10)
#   playlists.each do |playlist|
#     recordings.each_with_index do |recording, index|
#       PlaylistItem.find_or_create_by!(playlist:, item: recording) do |item|
#         item.position = index + 1
#       end
#     end
#   end
# end

# def like_playlists(playlists, user)
#   playlists.each do |playlist|
#     Like.find_or_create_by!(likeable: playlist, user:)
#   end
# end

# normal_user = User.find_by(email: "user@tangocloud.app")

# create_playlists_for_user(normal_user) if normal_user
