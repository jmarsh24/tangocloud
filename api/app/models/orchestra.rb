class Orchestra < ApplicationRecord
  has_many :orchestra_periods, dependent: :destroy
  has_many :orchestra_roles, dependent: :destroy
  has_many :recordings, dependent: :destroy
  has_many :compositions, through: :recordings
  has_many :singers, through: :recordings

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: orchestras
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  sort_name  :string
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
