class Period < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  searchkick word_middle: [:name], callbacks: :async

  belongs_to :record, counter_cache: true

  validates :name, presence: true
  validates :start_year, presence: true, numericality: {only_integer: true}
  validates :end_year, presence: true, numericality: {greater_than_or_equal_to: :start_year}
  validates :slug, presence: true, uniqueness: true
  validates :recordings_count, presence: true, numericality: {greater_than_or_equal_to: 0}

  has_one_attached :image

  def self.search_periods(query = "*")
    search(query,
      fields: ["name^5"],
      match: :word_middle,
      misspellings: {below: 5})
  end

  def search_data
    {
      name:,
      start_year:,
      end_year:
    }
  end
end

# == Schema Information
#
# Table name: periods
#
#  id               :uuid             not null, primary key
#  name             :string           not null
#  description      :text
#  start_year       :integer          default(0), not null
#  end_year         :integer          default(0), not null
#  recordings_count :integer          default(0), not null
#  slug             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
