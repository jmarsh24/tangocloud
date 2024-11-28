puts "Resetting counter caches..."

# Reset counter caches for Orchestras
puts "Resetting counter cache for Orchestras..."
Orchestra.find_each do |orchestra|
  Orchestra.reset_counters(orchestra.id, :recordings)
end

# Reset counter caches for Tandas
puts "Resetting counter cache for Tandas..."
Tanda.find_each do |tanda|
  tanda.update(
    playlists_count: tanda.playlist_items.count,
    recordings_count: tanda.recordings.count
  )
end

# Reset counter caches for Recordings
puts "Resetting counter cache for Recordings..."
Recording.find_each do |recording|
  Recording.reset_counters(recording.id, :tandas)
  Recording.reset_counters(recording.id, :playbacks)
  recording.update(playlists_count: PlaylistItem.where(item: recording).count)
end

puts "Counter caches reset completed!"
