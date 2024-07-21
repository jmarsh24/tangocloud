namespace :scrape do
  desc "Enqueue scraping jobs for a range of ERT numbers"
  task sync: :environment do
    total_songs = 18_502
    ert_numbers = (1..total_songs).to_a.shuffle

    sync_song_jobs = ert_numbers.map do
      ExternalCatalog::ElRecodo::SyncSongJob.new(ert_number: _1)
    end

    ActiveJob.perform_all_later(sync_song_jobs)

    puts "All #{total_songs} jobs have been enqueued."
  end

  desc "Enqueue scraping jobs for existing ERT numbers"
  task sync_existing: :environment do
    SyncExistingSongsJob.perform_later
    puts "SyncExistingSongsJob has been enqueued."
  end
end
