class Lyricist < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :compositions, dependent: :destroy, inverse_of: :lyricist
  has_many :lyrics, through: :compositions, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
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
