require "rails_helper"

RSpec.describe Import::Playlist::PlaylistImporter, type: :model do
  let!(:user) { create(:user, :approved) }
  let!(:audio_file_volver) { create(:audio_file, filename: "19401008_volver_a_sonar_roberto_rufino_tango_2476.flac") }
  let!(:composition_volver_a_sonar) { create(:composition, title: "Volver a soñar") }
  let!(:volver_a_sonar) { create(:recording, composition: composition_volver_a_sonar) }
  let!(:digital_remaster_volver) { create(:digital_remaster, audio_file: audio_file_volver, recording: volver_a_sonar) }

  let!(:audio_file_farol) { create(:audio_file, filename: "19430715_farol_roberto_chanel_tango_2099.flac") }
  let!(:composition_farol) { create(:composition, title: "Farol") }
  let!(:farol) { create(:recording, composition: composition_farol) }
  let!(:digital_remaster_farol) { create(:digital_remaster, audio_file: audio_file_farol, recording: farol) }

  let!(:playlist) { create(:playlist, user:) }

  describe "import" do
    it "creates a playlist with audio transfers in correct order" do
      imported_playlist = Import::Playlist::PlaylistImporter.new(playlist).import

      playlist_items = imported_playlist.playlist_items.ordered

      expect(playlist_items.count).to eq(2)
      expect(playlist_items.first.item).to eq(volver_a_sonar)
      expect(playlist_items.second.item).to eq(farol)
    end
  end
end
