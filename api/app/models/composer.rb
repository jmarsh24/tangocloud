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
#  id                 :uuid             not null, primary key
#  name               :string           not null
#  birth_date         :date
#  death_date         :date
#  slug               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  compositions_count :integer          default(0)
#
