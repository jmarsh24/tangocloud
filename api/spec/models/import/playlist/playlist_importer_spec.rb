require "rails_helper"

RSpec.describe Import::Playlist::PlaylistImporter, type: :model do
  fixtures :users, :audio_transfers

  describe "import" do
    it "creates a playlist with audio transfers in correct order" do
      playlist = Playlist.new(title: "Awesome Playlist", user: users(:admin))
      playlist.image.attach(io: File.open("spec/fixtures/files/avatar.jpg"), filename: "avatar.jpg")
      playlist.playlist_file.attach(io: File.open("spec/fixtures/files/awesome_playlist.m3u8"), filename: "awesome_playlist.m3u8")

      playlist.save!

      file = File.open("spec/fixtures/files/awesome_playlist.m3u8")
      playlist.playlist_file.attach(io: file, filename: "awesome_playlist.m3u8")

      volver_a_sonar = audio_transfers(:volver_a_sonar_tango_tunes_1940_audio_transfer)
      no_te_apures_carablanca = AudioTransfer.create!(filename: "19421009_no_te_apures_carablanca_juan_carlos_miranda_tango_1918.m4a")
      comme_il_faut = AudioTransfer.create!(filename: "19380307_comme_il_faut_instrumental_tango_2758.aif")

      playlist = described_class.new(playlist).import
      audio_transfers = playlist.audio_transfers
      expect(audio_transfers.count).to eq(3)
      expect(audio_transfers.first).to eq(volver_a_sonar)
      expect(audio_transfers.second).to eq(no_te_apures_carablanca)
      expect(audio_transfers.third).to eq(comme_il_faut)
    end
  end
end
