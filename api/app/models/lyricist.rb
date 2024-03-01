class Lyricist < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  searchkick word_middle: [:name], callbacks: :async

  has_many :compositions, dependent: :destroy, inverse_of: :lyricist
  has_many :lyrics, through: :compositions
  has_many :recordings, through: :compositions

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def self.search_lyricists(query = "*")
    search(query,
      fields: ["name^5"],
      match: :word_middle,
      misspellings: {below: 5})
  end

  def search_data
    {
      name:
    }
  end
end

# == Schema Information
#
# Table name: lyricists
#
#  id                 :uuid             not null, primary key
#  name               :string           not null
#  slug               :string           not null
#  sort_name          :string
#  birth_date         :date
#  death_date         :date
#  bio                :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  compositions_count :integer          default(0)
#
