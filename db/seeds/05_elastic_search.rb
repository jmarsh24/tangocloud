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

progressbar = ProgressBar.create(total: models.size)

models.each do |model|
  model.reindex
  progressbar.increment
end
