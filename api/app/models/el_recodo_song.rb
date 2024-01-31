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
class ElRecodoSong < ApplicationRecord
  searchkick word_middle: [:title, :composer, :author, :lyrics, :orchestra, :singer]

  validates :date, presence: true
  validates :ert_number, presence: true
  validates :music_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :page_updated_at, presence: true

  def self.search_songs(query, page: 1, per_page: 10)
    search(query,
      fields: ["title^5", "composer", "author", "lyrics", "orchestra", "singer"],
      match: :word_middle,
      misspellings: {below: 5},
      page:,
      per_page:,
      load: false)
  end

  def search_data
    {
      date:,
      ert_number:,
      music_id:,
      title:,
      style:,
      orchestra:,
      singer:,
      composer:,
      author:,
      label:,
      lyrics:,
      soloist:,
      director:
    }
  end
end
