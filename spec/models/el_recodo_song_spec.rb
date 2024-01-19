# frozen_string_literal: true

# == Schema Information
#
# Table name: el_recodo_songs
#
#  id                   :integer          not null, primary key
#  date                 :date             not null
#  ert_number           :integer          default(0), not null
#  music_id             :integer          default(0), not null
#  title                :string           not null
#  style                :string
#  orchestra            :string
#  singer               :string
#  composer             :string
#  author               :string
#  label                :string
#  lyrics               :text
#  normalized_title     :string
#  normalized_orchestra :string
#  normalized_singer    :string
#  normalized_composer  :string
#  normalized_author    :string
#  search_data          :string
#  synced_at            :datetime         not null
#  page_updated_at      :datetime         not null
#  recording_id         :uuid
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require "rails_helper"

RSpec.describe ElRecodoSong do
  describe ".search" do
    it "returns songs that match the query with mispelling" do
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
      expect(ElRecodoSong.search("rodofo biag").first).to eq(song)
    end
  end

  describe ".normalize_text_field" do
    it "normalizes text" do
      expect(ElRecodoSong.normalize_text_field(" Áé íóú ")).to eq("ae iou")
    end

    it "returns nil if the input is not a string" do
      expect(ElRecodoSong.normalize_text_field(nil)).to_be nil
    end

    it "returns empty string if the input is blank" do
      expect(ElRecodoSong.normalize_text_field(" ")).to eq("")
    end
  end

  describe ".sync_songs" do
    before do
      stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en").to_return(status: 200, body: File.read("spec/fixtures/el_recodo_song.html"))
    end

    it "creates a new song" do
      freeze_time
      expect { ElRecodoSong.sync_songs(to: 1) }.to change(ElRecodoSong, :count).by(1)
      song = ElRecodoSong.find_by(music_id: 1)

      expect(song.ert_number).to eq(1)
      expect(song.title).to eq("Te burlas tristeza")
      expect(song.date).to eq(Date.new(1960, 7, 28))
      expect(song.style).to eq("TANGO")
      expect(song.orchestra).to eq("Rodolfo BIAGI")
      expect(song.singer).to eq("Hugo Duval")
      expect(song.composer).to eq("Edmundo Baya")
      expect(song.author).to eq("Julio César Curi")
      expect(song.label).to eq("Columbia")
      expect(song.music_id).to eq(1)
      expect(song.normalized_title).to eq("te burlas tristeza")
      expect(song.normalized_orchestra).to eq("rodolfo biagi")
      expect(song.normalized_singer).to eq("hugo duval")
      expect(song.normalized_composer).to eq("edmundo baya")
      expect(song.normalized_author).to eq("julio cesar curi")
      expect(song.search_data).to eq("te burlas tristeza rodolfo biagi hugo duval edmundo baya julio cesar curi")
      expect(song.page_updated_at).to eq(Time.zone.parse("2018-10-14 02:00:00.000000000 +0200"))
      expect(song.synced_at).to eq(Time.zone.now)
    end

    it "updates an existing song" do
      ElRecodoSong.create!(
        ert_number: 0,
        music_id: 1,
        title: "foo",
        date: Date.today,
        page_updated_at: Time.now,
        style: "foo",
        orchestra: "foo",
        singer: "foo",
        composer: "foo",
        author: "foo",
        label: "foo",
        lyrics: "foo"
      )

      expect { ElRecodoSong.sync_songs(to: 1) }.to change { ElRecodoSong.find_by(music_id: 1).title }.from("foo").to("Te burlas tristeza")
      expect { ElRecodoSong.sync_songs(to: 1) }.to not_to change
    end
  end

  describe ".update_search_data" do
    before do
      ElRecodoSong.create!(
        ert_number: 0,
        music_id: 1,
        title: "fóö",
        date: Date.today,
        page_updated_at: Time.now,
        style: "foo",
        orchestra: "órchêstrà",
        singer: "sînger",
        composer: "fôô",
        author: "fóô"
      )
      ElRecodoSong.find_by(music_id: 1).update_search_data
    end

    it "updates the search data with normalized and accent-removed text" do
      expect(ElRecodoSong.find_by(music_id: 1).search_data).to eq("foo orchestra singer foo foo")
    end

    it "updates the normalized fields" do
      song = ElRecodoSong.find_by(music_id: 1)
      expect(song.normalized_title).to eq("foo")
      expect(song.normalized_orchestra).to eq("orchestra")
      expect(song.normalized_singer).to eq("singer")
      expect(song.normalized_composer).to eq("foo")
      expect(song.normalized_author).to eq("foo")
    end
  end
end
