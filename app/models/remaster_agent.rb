class RemasterAgent < ApplicationRecord
  has_many :digital_remasters, dependent: :destroy

  validates :name, presence: true
end

# == Schema Information
#
# Table name: remaster_agents
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
