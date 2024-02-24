class Orchestra < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :recordings
  has_many :singers, through: :recordings
  has_many :compositions, through: :recordings
  has_many :composers, through: :compositions
  has_many :lyricists, through: :compositions

  validates :name, presence: true
  validates :rank, presence: true, numericality: {only_integer: true}
  validates :slug, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: orchestras
#
#  id               :uuid             not null, primary key
#  name             :string           not null
#  rank             :integer          default(0), not null
#  sort_name        :string
#  birth_date       :date
#  death_date       :date
#  slug             :string           not null
#  recordings_count :integer          default(0)
#
