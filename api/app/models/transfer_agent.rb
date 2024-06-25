class TransferAgent < ApplicationRecord
  validates :name, presence: true
  has_many :audio_transfers, dependent: :destroy

  has_one_attached :image
  has_one_attached :logo
end

# == Schema Information
#
# Table name: transfer_agents
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
