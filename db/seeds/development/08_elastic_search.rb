puts "Reindexing models..."

models = [
  Genre,
  Orchestra,
  Person,
  Playlist,
  Recording,
  TimePeriod,
  User,
  Tanda,
  ExternalCatalog::ElRecodo::Person,
  ExternalCatalog::ElRecodo::Orchestra,
  ExternalCatalog::ElRecodo::Song
]

progressbar = ProgressBar.create(total: models.size)

models.each do |model|
  model.reindex
  progressbar.increment
end
