require "rails_helper"

RSpec.describe Playlist, type: :model do
  describe "#set_default_title" do
    it "sets the title to the playlist_file filename if title is blank and playlist_file is attached" do
      playlist = Playlist.new(title: nil)
      playlist.playlist_file.attach(io: File.open(Rails.root.join("spec/fixtures/files/awesome_playlist.m3u8")), filename: "T Biagi 38-42.m3u8")
      playlist.save
      expect(playlist.title).to eq("T Biagi 38-42")
    end
  end
end

# == Schema Information
#
# Table name: playlists
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  subtitle    :string
#  description :text
#  slug        :string
#  public      :boolean          default(TRUE), not null
#  system      :boolean          default(FALSE), not null
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
