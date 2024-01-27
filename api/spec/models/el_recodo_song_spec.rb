# frozen_string_literal: true

# == Schema Information
#
# Table name: el_recodo_songs
#
#  id              :uuid             not null, primary key
#  date            :date             not null
#  ert_number      :integer          default(0), not null
#  music_id        :integer          default(0), not null
#  title           :string           not null
#  style           :string
#  orchestra       :string
#  singer          :string
#  composer        :string
#  author          :string
#  label           :string
#  lyrics          :text
#  search_data     :string
#  synced_at       :datetime         not null
#  page_updated_at :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  soloist         :string
#  director        :string
#
require "rails_helper"

RSpec.describe ElRecodoSong do
  describe ".search" do
    xit "returns songs that match the query with mispelling" do

      stub_request(:get, "http://localhost:9208/el_recodo_songs_test*/_alias").to_return(status: 200, body: "", headers: {})
      stub_request(:post, "http://localhost:9208/_bulk").to_return(status: 200, body: "", headers: {})
      stub_request(:post, "http://localhost:9208/el_recodo_songs_test/_search").to_return(status: 200, body: "", headers: {})

      song = ElRecodoSong.create!(
        ert_number: 0,
        music_id: 1,
        title: "foo",
        date: Date.today,
        page_updated_at: Time.now,
        style: "foo",
        orchestra: "Rodolfo BIAGI",
        singer: "Hugo Duval",
        composer: "Edmundo Baya",
        author: "Julio César Curi"
      )

      song.reindex

      expect(ElRecodoSong.search("rodolf biagi").results.first).to eq(song)
    end
  end
end
