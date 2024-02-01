class Composition < ApplicationRecord
  belongs_to :lyricist
  belongs_to :composer
  has_many :recordings, dependent: :destroy
  has_many :lyrics, dependent: :destroy

  validates :title, presence: true
  validates :genre_id, presence: true
  validates :lyricist_id, presence: true
  validates :composer_id, presence: true
  validates :listens_count, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :popularity, presence: true, numericality: {greater_than_or_equal_to: 0}
end

# == Schema Information
#
# Table name: compositions
#
#  id             :uuid             not null, primary key
#  title          :string           not null
#  tangotube_slug :string
#  lyricist_id    :uuid             not null
#  composer_id    :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
