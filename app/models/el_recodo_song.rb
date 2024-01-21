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
  include TextNormalizable

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
