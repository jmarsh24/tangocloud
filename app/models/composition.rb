class Composition < ApplicationRecord
  has_many :recordings, dependent: :destroy
  has_many :composition_lyrics, dependent: :destroy
  has_many :composition_roles, dependent: :destroy
  has_many :lyrics, through: :composition_lyrics
  has_many :composers, -> { where(composition_roles: {role: "composer"}) }, through: :composition_roles, source: :person
  has_many :lyricists, -> { where(composition_roles: {role: "lyricist"}) }, through: :composition_roles, source: :person

  validates :title, presence: true
end

# == Schema Information
#
# Table name: compositions
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
