namespace :acr_cloud do
  desc "Process all DigitalRemaster records without AcrCloudRecognition"

  task process_missing: :environment do
    DigitalRemaster.where.missing(:acr_cloud_recognition).find_each do |digital_remaster|
      puts "Processing DigitalRemaster ID: #{digital_remaster.id}"
      digital_remaster.perform_acr_cloud_recognition(async: true)
    rescue => e
      puts "Failed to process DigitalRemaster ID: #{digital_remaster.id}. Error: #{e.message}"
    end
    puts "Processing complete!"
  end
end
