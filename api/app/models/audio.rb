class Audio < ApplicationRecord
  belongs_to :audio_transfer, dependent: :destroy
  has_many :transfer_agents, through: :audio_transfers

  validates :duration, presence: true
  validates :format, presence: true
  validates :bit_rate, numericality: {only_integer: true}
  validates :sample_rate, numericality: {only_integer: true}
  validates :channels, numericality: {only_integer: true}

  has_one_attached :file, dependent: :purge_later
end

# == Schema Information
#
# Table name: audios
#
#  id                :uuid             not null, primary key
#  duration          :integer          default(0), not null
#  format            :string           not null
#  codec             :string           not null
#  bit_depth         :integer
#  bit_rate          :integer
#  sample_rate       :integer
#  channels          :integer
#  length            :integer          default(0), not null
#  metadata          :jsonb            not null
#  audio_transfer_id :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
