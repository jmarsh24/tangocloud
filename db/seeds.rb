Searchkick.disable_callbacks

# Load common seeds
Dir[Rails.root.join("db/seeds/common/*.rb")].each do |seed|
  puts "Loading common seed: #{File.basename(seed)}"
  load seed
end

Dir[Rails.root.join("db/seeds/#{Rails.env}/*.rb")].each do |seed|
  puts "Loading #{Rails.env} seed: #{File.basename(seed)}"
  load seed
end

puts "Seeds loaded successfully."
