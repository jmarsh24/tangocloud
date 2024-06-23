class Lyricist < ApplicationRecord
  extend FriendlyId
  include Titleizable
  friendly_id :name, use: :slugged

  searchkick word_middle: [:name], callbacks: :async

  has_many :compositions, dependent: :destroy, inverse_of: :lyricist
  has_many :lyrics, through: :compositions
  has_many :recordings, through: :compositions

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  has_one_attached :photo, dependent: :purge_later do |blob|
    blob.variant :thumb, resize_to_limit: [100, 100]
    blob.variant :medium, resize_to_limit: [250, 250]
    blob.variant :large, resize_to_limit: [500, 500]
  end

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
# Table name: lyricists
#
#  id                 :uuid             not null, primary key
#  first_name         :string           not null
#  last_name          :string           not null
#  slug               :string           not null
#  sort_name          :string
#  birth_date         :date
#  death_date         :date
#  bio                :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  compositions_count :integer          default(0)
#  normalized_name    :string
#
