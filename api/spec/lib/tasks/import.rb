namespace :import do
  desc "Import music files"
  task music: :environment do
    music_directory = Rails.root.join("/Users/jm_mbp/Library/CloudStorage/GoogleDrive-jmarsh24@gmail.com/My Drive/[1] private_life/[ 3 ] Music/tangocloud")
    ImportImporter::SUPPORTED_FORMATS
      .Dir.glob("#{music_directory}/*.{#{song_formats}}").each do |file_path|
      ImportImporter.new(file_path).import
    end
  end
end
