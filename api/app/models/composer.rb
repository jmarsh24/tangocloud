class Composer < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  searchkick word_middle: [:name]

  has_many :compositions, dependent: :destroy
  has_many :recordings, through: :compositions

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :normalized_name, presence: true, uniqueness: true

  has_one_attached :photo

  before_save :set_normalized_name

  def self.search_composers(query = "*")
    Composer.search(query,
      match: :word_middle,
      misspellings: {below: 5})
  end

  def search_data
    {
      name:
    }
  end

  def set_normalized_name
    self.normalized_name = I18n.transliterate(name).downcase
  end
end

# == Schema Information
#
# Table name: composers
#
#  id                 :uuid             not null, primary key
#  name               :string           not null
#  birth_date         :date
#  death_date         :date
#  slug               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  compositions_count :integer          default(0)
#  normalized_name    :string
#
