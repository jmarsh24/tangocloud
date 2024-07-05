class Singer < ApplicationRecord
  extend FriendlyId
  include Titleizable
  friendly_id :name, use: :slugged
  searchkick word_start: [:name], callbacks: :async

  has_many :recording_singers, dependent: :destroy
  has_many :recordings, through: :recording_singers

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :rank, presence: true, numericality: {only_integer: true}

  has_one_attached :photo

  def search_data
    {
      name:
    }
  end
end

# == Schema Information
#
# Table name: singers
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  rank       :integer          default(0), not null
#  soloist    :boolean          default(FALSE), not null
#  sort_name  :string
#  bio        :text
#  birth_date :date
#  death_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
