class OrchestraRole < ApplicationRecord
  has_many :orchestra_roles, dependent: :destroy

  validates :name, presence: true
end

# == Schema Information
#
# Table name: orchestra_roles
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
