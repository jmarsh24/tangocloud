class Composer < ApplicationRecord
  extend FriendlyId
  include Titleizable
  friendly_id :name, use: :slugged

  searchkick word_middle: [:name]

  has_many :compositions, dependent: :destroy
  has_many :recordings, through: :compositions

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :slug, presence: true, uniqueness: true

  has_one_attached :photo

  def search_data
    {
      name:
    }
  end

  def name
    "#{first_name} #{last_name}"
  end
end

# == Schema Information
#
# Table name: composers
#
#  id                 :uuid             not null, primary key
#  first_name         :string           not null
#  last_name          :string           not null
#  birth_date         :date
#  death_date         :date
#  sort_name          :string
#  slug               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  compositions_count :integer          default(0)
#  normalized_name    :string
#
