class OrchestraRole < ApplicationRecord
  has_many :orchestra_positions, dependent: :destroy
  has_many :orchestras, through: :orchestra_positions
  has_many :people, through: :orchestra_positions

  validates :name, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: orchestra_roles
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
