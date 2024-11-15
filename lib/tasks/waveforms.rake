namespace :waveforms do
  desc "Enqueue jobs to update waveform data for all DigitalRemaster records"
  task update: :environment do
    DigitalRemaster.find_each do |digital_remaster|
      UpdateWaveformDataJob.perform_later(digital_remaster)
    end

    puts "Enqueued jobs for all DigitalRemaster records."
  end
end
