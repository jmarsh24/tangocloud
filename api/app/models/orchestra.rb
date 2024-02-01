# == Schema Information
#
# Table name: orchestras
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  rank       :integer          default(0), not null
#  sort_name  :string
#  birth_date :date
#  death_date :date
#  slug       :string           not null
#
class Orchestra < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :orchestra_recordings, dependent: :destroy
  has_many :recordings, through: :orchestra_recordings
  has_many :singers, through: :recordings
  has_many :compositions, through: :recordings
  has_many :composers, through: :compositions
  has_many :lyricists, through: :compositions

  validates :name, presence: true
  validates :rank, presence: true, numericality: {only_integer: true}
  validates :sort_name, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :set_sort_name

  private

  def set_sort_name
    self.sort_name = I18n.transliterate(name).downcase
  end
end
