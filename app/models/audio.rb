# frozen_string_literal: true

# == Schema Information
#
# Table name: audios
#
#  id            :uuid             not null, primary key
#  format        :string           not null
#  bit_rate      :integer
#  sample_rate   :integer
#  channels      :integer
#  bit_depth     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  bit_rate_mode :string
#  codec         :string
#  file_size     :integer
#  length        :float
#  encoder       :string
#  filename      :string
#
class Audio < ApplicationRecord
  has_many :audio_transfers, dependent: :destroy
  has_many :transfer_agents, through: :audio_transfers

  validates :duration, presence: true
  validates :format, presence: true
  validates :bit_rate, numericality: {only_integer: true}
  validates :sample_rate, numericality: {only_integer: true}
  validates :channels, numericality: {only_integer: true}
  validates :bit_depth, numericality: {only_integer: true}

  has_one_attached :file, dependent: :purge_later
end
