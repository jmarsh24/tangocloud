# frozen_string_literal: true

# == Schema Information
#
# Table name: el_recodo_songs
#
#  id                   :uuid             not null, primary key
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
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  soloist              :string
#  director             :string
#  normalized_soloist   :string
#  normalized_director  :string
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
      expect(ElRecodoSong.search("rodolf biagi").first).to eq(song)
    end
  end

  describe ".normalize_text_field" do
    it "normalizes text" do
      expect(ElRecodoSong.normalize_text_field(" Áé íóú ")).to eq("ae iou")
    end

    it "returns nil if the input is not a string" do
      expect(ElRecodoSong.normalize_text_field(nil)).to be_nil
    end

    it "returns empty string if the input is blank" do
      expect(ElRecodoSong.normalize_text_field(" ")).to eq("")
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
