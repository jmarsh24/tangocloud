class Person < ApplicationRecord
  has_many :composition_roles, dependent: :destroy
  has_many :orchestra_roles, dependent: :destroy
  has_many :recording_singers, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: people
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  sort_name  :string
#  bio        :text
#  birth_date :date
#  death_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
