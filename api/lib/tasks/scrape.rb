namespace :scrape do
  desc "Enqueue scraping jobs for a range of ERT numbers"
  task sync: :environment do
    synchronizer = ExternalCatalog::ElRecodo::SongSynchronizer.new
    synchronizer.sync_range(1..18502)
  end

  desc "Enqueue scraping jobs for existing ERT numbers"
  task sync_existing: :environment do
    synchronizer = ExternalCatalog::ElRecodo::SongSynchronizer.new
    synchronizer.sync_existing
  end
end
