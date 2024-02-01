class Lyricist < ApplicationRecord
  extend FriendlyId
  has_many :lyrics, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
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
