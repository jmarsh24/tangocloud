puts "Reindexing all Searchkick models..."

searchkick_models = Searchkick.models

progressbar = ProgressBar.create(total: searchkick_models.size)

searchkick_models.each do |model|
  model.reindex
  progressbar.increment
end

puts "Reindexing completed!"
