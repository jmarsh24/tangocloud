class Composer < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  searchkick word_middle: [:name]

  has_many :compositions, dependent: :destroy

  validates :name, presence: true

  has_one_attached :photo

  def self.search_composers(query)
    Composer.search(query,
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
#
