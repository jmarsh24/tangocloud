class TimePeriod < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  searchkick word_start: [:name], callbacks: :async

  has_many :recordings, dependent: :nullify

  validates :name, presence: true
  validates :start_year, presence: true, numericality: {only_integer: true}
  validates :end_year, presence: true, numericality: {greater_than_or_equal_to: :start_year}
  validates :slug, presence: true, uniqueness: true

  has_one_attached :image

  scope :covering_year, ->(year) { where("? BETWEEN start_year AND end_year", year) }

  private

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
# Table name: time_periods
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  start_year  :integer          default(0), not null
#  end_year    :integer          default(0), not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
