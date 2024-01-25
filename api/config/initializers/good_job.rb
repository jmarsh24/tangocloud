# frozen_string_literal: true

Rails.application.configure do
  config.good_job.preserve_job_records = true
  config.good_job.retry_on_unhandled_error = false
  config.good_job.on_thread_error = ->(exception) { Rails.error.report(exception) }
  config.good_job.execution_mode = :external
  config.good_job.retry_on_unhandled_error = false
  config.good_job.queues = "background_sync:1;-background_sync:2"
  config.good_job.poll_interval = 5 # seconds
  config.good_job.shutdown_timeout = 120 # seconds
  config.good_job.max_threads = 3
  config.good_job.dashboard_default_locale = :en
  config.good_job.enable_cron = Rails.env.production?
  config.good_job.cron = {
    channel_video_sync: {
      cron: "0 0 * * 0", # every sunday at midnight
      class: "Import::ElRecodo::SyncSongsJob"
    }
  }
end
