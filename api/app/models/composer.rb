class Composer < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :compositions, dependent: :destroy

  validates :name, presence: true
end

# == Schema Information
#
# Table name: composers
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  birth_date :date
#  death_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string           not null
#
