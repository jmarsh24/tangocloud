class Lyricist < ApplicationRecord
  extend FriendlyId
  include Titleizable
  friendly_id :name, use: :slugged

  searchkick word_start: [:name, :sort_name], callbacks: :async

  has_many :compositions, dependent: :destroy, inverse_of: :lyricist
  has_many :shares, as: :shareable, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  has_one_attached :photo

  def search_data
    {
      first_name:,
      last_name:,
      name:
    }
  end
end

# == Schema Information
#
# Table name: lyricists
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  sort_name  :string
#  birth_date :date
#  death_date :date
#  bio        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
