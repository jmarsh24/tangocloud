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
class ElRecodoSong < ApplicationRecord
  validates :date, presence: true
  validates :ert_number, presence: true
  validates :music_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :page_updated_at, presence: true

  before_validation :update_search_data

  scope :search, ->(query) {
                   return all if query.blank?

                   sanitized_query = sanitize_sql_like(query.downcase)
                   select("*, similarity(search_data, '#{sanitized_query}') AS similarity")
                     .where("? <% search_data", sanitized_query)
                     .order("similarity DESC")
                 }

  class << self
    def normalize_text_field(text)
      return text unless text.is_a?(String)

      I18n.transliterate(text).downcase.strip
    end

    def sync_songs(from: 1, to: 20_000, batch_size: 100, interval: 30)
      should_stop = false

      (from..to).each_slice(batch_size) do |batch|
        break if should_stop == true

        song_data_batch = []
        batch.each do |music_id|
          sleep(interval)
          Rails.logger.info("Syncing song #{music_id}...")

          begin
            song_metadata = Import::ElRecodo::SongScraper.new(music_id).metadata
          rescue Import::ElRecodo::SongScraper::TooManyRequestsError
            should_stop = true
            break
          end

          if song_metadata.blank?
            Rails.logger.info("Song #{music_id} not found")
            next
          end

          normalized_title = normalize_text_field(song_metadata.title)
          normalized_orchestra = normalize_text_field(song_metadata.orchestra)
          normalized_singer = normalize_text_field(song_metadata.singer)
          normalized_composer = normalize_text_field(song_metadata.composer)
          normalized_author = normalize_text_field(song_metadata.author)

          search_data = [
            normalized_title,
            normalized_orchestra,
            normalized_singer,
            normalized_composer,
            normalized_author
          ].join(" ")

          metadata = song_metadata.to_h.merge!(
            normalized_title:,
            normalized_orchestra:,
            normalized_singer:,
            normalized_composer:,
            normalized_author:,
            search_data:
          )

          song_data_batch << metadata
        end

        ElRecodoSong.upsert_all(song_data_batch, unique_by: :music_id)
      end
    end
  end

  def update_search_data
    self.normalized_title = self.class.normalize_text_field(title)
    self.normalized_orchestra = self.class.normalize_text_field(orchestra)
    self.normalized_singer = self.class.normalize_text_field(singer)
    self.normalized_composer = self.class.normalize_text_field(composer)
    self.normalized_author = self.class.normalize_text_field(author)

    fields_to_search = [
      normalized_title,
      normalized_orchestra,
      normalized_singer,
      normalized_composer,
      normalized_author
    ]

    self.search_data = fields_to_search.join(" ")
  end
end
