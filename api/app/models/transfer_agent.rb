class TransferAgent < ApplicationRecord
  validates :name, presence: true
  has_many :audio_transfers, dependent: :destroy
  has_many :audio_variants, through: :audio_transfers, dependent: :destroy
  has_many :recordings, through: :audio_transfers, dependent: :destroy

  has_one_attached :image, dependent: :purge_later do |blob|
    blob.variant :thumb, resize_to_limit: [100, 100]
    blob.variant :medium, resize_to_limit: [250, 250]
    blob.variant :large, resize_to_limit: [500, 500]
  end
  has_one_attached :logo, dependent: :purge_later do |blob|
    blob.variant :thumb, resize_to_limit: [100, 100]
    blob.variant :medium, resize_to_limit: [250, 250]
    blob.variant :large, resize_to_limit: [500, 500]
  end
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
