namespace :scrape do
  desc "Enqueue scraping jobs for a range of ERT numbers"
  task sync: :environment do
    total_songs = 18_502

    (1..total_songs).to_a.shuffle.each_slice(1000) do |batch|
      batch.each do |ert_number|
        ExternalCatalog::ElRecodo::SyncSongJob.perform_later(ert_number:)
      end
      puts "Enqueued batch of #{batch.size} jobs..."
    end

    puts "All #{total_songs} jobs have been enqueued."
  end

  desc "Enqueue scraping jobs for existing ERT numbers"
  task sync_existing: :environment do
    SyncExistingSongsJob.perform_later
    puts "SyncExistingSongsJob has been enqueued."
  end
end
