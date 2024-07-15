class Orchestra < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  searchkick word_start: [:name]

  has_many :orchestra_periods, dependent: :destroy
  has_many :orchestra_roles, dependent: :destroy
  has_many :recordings, dependent: :destroy
  has_many :compositions, through: :recordings
  has_many :singers, through: :recordings
  has_many :genres, through: :recordings

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  has_one_attached :photo

  def search_data
    {
      id:,
      name:,
      periods: orchestra_periods.pluck(:name),
      roles: orchestra_roles.pluck(:name),
      singers: singers.pluck(:name),
      genres: genres.pluck(:name)
    }
  end
end

# == Schema Information
#
# Table name: orchestras
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  sort_name  :string
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
