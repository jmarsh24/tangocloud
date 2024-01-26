# frozen_string_literal: true

# == Schema Information
#
# Table name: albums
#
#  id                :uuid             not null, primary key
#  title             :string           not null
#  description       :text
#  release_date      :date
#  recordings_count  :integer          default(0), not null
#  slug              :string           not null
#  external_id       :string
#  transfer_agent_id :uuid
#  type              :enum             default("compilation"), not null
#
class Album < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :transfer_agent, optional: true
  has_many :recordings, dependent: :destroy

  enum type: {compilation: "compilation", original: "original"}

  validates :title, presence: true
  validates :type, presence: true, inclusion: {in: Album.types.keys}
  validates :recordings_count, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :slug, presence: true, uniqueness: true

  has_one_attached :cover_image, dependent: :purge_later do |blob|
    blob.variant :thumb, resize: "100x100"
    blob.variant :medium, resize: "300x300"
    blob.variant :large, resize: "500x500"
  end

  class << self
    def search(query)
      return all if query.blank?

      sanitized_query = sanitize_sql_like(query.downcase)
      select("*, similarity(title, '#{sanitized_query}') AS similarity")
        .where("title % ?", sanitized_query)
        .order("similarity DESC")
    end
  end
end
