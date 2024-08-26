puts "Reindexing models..."

models = [
  Album,
  Genre,
  Orchestra,
  Person,
  Playlist,
  Recording,
  TimePeriod,
  User,
  ExternalCatalog::ElRecodo::Person,
  ExternalCatalog::ElRecodo::Orchestra,
  ExternalCatalog::ElRecodo::Song
]

progressbar = ProgressBar.create(total: models.size)

models.each do |model|
  model.reindex
  progressbar.increment
end
