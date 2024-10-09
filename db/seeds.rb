Searchkick.disable_callbacks

Dir[Rails.root.join("db/seeds/#{Rails.env}/*.rb")].each do |seed|
  load seed
end

puts "Seeds loaded successfully."
