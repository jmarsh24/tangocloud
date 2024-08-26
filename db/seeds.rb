Searchkick.disable_callbacks

Dir[Rails.root.join("db/seeds/*.rb")].each do |seed|
  load seed
end
