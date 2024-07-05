require "rails_helper"

RSpec.describe Import::Playlist::PlaylistImporter, type: :model do
  let!(:user) { create(:user) }
  let!(:audio_file_volver) { create(:audio_file, filename: "19401008_volver_a_sonar_roberto_rufino_tango_2476.flac") }
  let!(:audio_transfer_volver) { create(:audio_transfer, audio_file: audio_file_volver) }
  let!(:volver_a_sonar) { create(:recording, title: "Volver a soñar", audio_transfers: [audio_transfer_volver]) }

  let!(:audio_file_farol) { create(:audio_file, filename: "19430715_farol_roberto_chanel_tango_2099.flac") }
  let!(:audio_transfer_farol) { create(:audio_transfer, audio_file: audio_file_farol) }
  let!(:farol) { create(:recording, title: "Farol", audio_transfers: [audio_transfer_farol]) }

  let(:playlist) { create(:playlist, user:) }

  describe "import" do
    it "creates a playlist with audio transfers in correct order" do
      imported_playlist = Import::Playlist::PlaylistImporter.new(playlist).import

      playlist_items = imported_playlist.items

      expect(playlist_items.count).to eq(2)
      expect(playlist_items.first.item).to eq(volver_a_sonar)
      expect(playlist_items.second.item).to eq(farol)
    end
  end
end
