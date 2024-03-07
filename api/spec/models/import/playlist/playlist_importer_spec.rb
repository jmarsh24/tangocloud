require "rails_helper"

RSpec.describe Import::Playlist::PlaylistImporter, type: :model do
  let(:desde_el_alma) { recordings(:desde_el_alma) }
  let(:milonga_vieja_milonga) { recordings(:milonga_vieja_milonga) }
  let(:volver_a_sonar) { recordings(:volver_a_sonar) }
  let(:te_aconsejo_que_me_olvides) { recordings(:te_aconsejo_que_me_olvides) }
  let(:farol) { recordings(:farol) }

  describe "import" do
    it "creates a playlist with audio transfers in correct order" do
      playlist = Playlist.new(title: "Awesome Playlist", user: users(:admin))
      playlist.image.attach(io: File.open("spec/fixtures/files/avatar.jpg"), filename: "avatar.jpg")
      playlist.playlist_file.attach(io: File.open("spec/fixtures/files/awesome_playlist.m3u8"), filename: "awesome_playlist.m3u8")

      playlist.save!

      file = File.open("spec/fixtures/files/awesome_playlist.m3u8")
      playlist.playlist_file.attach(io: file, filename: "awesome_playlist.m3u8")

      playlist = described_class.new(playlist).import
      playlist_items = playlist.playlist_items
      expect(playlist_items.count).to eq(5)
      expect(playlist_items[0].playable).to eq(desde_el_alma)
      expect(playlist_items[1].playable).to eq(milonga_vieja_milonga)
      expect(playlist_items[2].playable).to eq(volver_a_sonar)
      expect(playlist_items[3].playable).to eq(te_aconsejo_que_me_olvides)
      expect(playlist_items[4].playable).to eq(farol)
    end
  end
end
