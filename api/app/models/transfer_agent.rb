# frozen_string_literal: true

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
class TransferAgent < ApplicationRecord
  validates :name, presence: true
  has_many :audio_transfers, dependent: :destroy
  has_many :audios, through: :audio_transfers, dependent: :destroy
  has_many :recordings, through: :audio_transfers, dependent: :destroy

  has_one_attached :image, dependent: :purge_later do |blob|
    blob.variant :thumb, resize: "100x100"
    blob.variant :medium, resize: "300x300"
    blob.variant :large, resize: "500x500"
  end
  has_one_attached :logo, dependent: :purge_later do |blob|
    blob.variant :thumb, resize: "100x100"
    blob.variant :medium, resize: "300x300"
    blob.variant :large, resize: "500x500"
  end
end
