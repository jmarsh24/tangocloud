puts "Reindexing models..."

models = [
  ExternalCatalog::ElRecodo::Song,
  Recording,
  Playlist,
  Person,
  Genre,
  Orchestra,
  User
]

progress_bar = ProgressBar.new(models.size)

models.each do |model|
  model.reindex
  progress_bar.increment
end
