namespace :scrape do
  desc "Enqueue scraping jobs for a range of ERT numbers"
  task sync: :environment do
    total_songs = 18_502
    ert_numbers = (1..total_songs).to_a.shuffle

    progressbar = ProgressBar.create(
      title: "Enqueuing Jobs",
      total: total_songs,
      format: "%t: |%B| %p%% %a",
      throttle_rate: 0.1
    )

    ert_numbers.each_slice(1000).with_index do |batch, index|
      sync_song_jobs = batch.map do |ert_number|
        ExternalCatalog::ElRecodo::SyncSongJob.new(ert_number:)
      end

      ActiveJob.perform_all_later(sync_song_jobs)
      progressbar.progress += batch.size

      puts "Enqueued batch #{index + 1} of #{(total_songs / 1000.0).ceil}"
    end

    progressbar.finish

    puts "All #{total_songs} jobs have been enqueued."
  end

  desc "Enqueue scraping jobs for existing ERT numbers"
  task sync_existing: :environment do
    SyncExistingSongsJob.perform_later
    puts "SyncExistingSongsJob has been enqueued."
  end
end
