class Composition < ApplicationRecord
  has_many :recordings, dependent: :destroy
  has_many :composition_lyrics, dependent: :destroy
  has_many :composition_roles, dependent: :destroy
  has_many :lyrics, through: :composition_lyrics

  validates :title, presence: true
end

# == Schema Information
#
# Table name: compositions
#
#  id         :uuid             not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
