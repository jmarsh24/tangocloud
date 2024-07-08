class AudioVariant < ApplicationRecord
  belongs_to :digital_remaster

  validates :duration, presence: true
  validates :format, presence: true
  validates :bit_rate, numericality: {only_integer: true}

  has_one_attached :audio_file, dependent: :purge_later
end

# == Schema Information
#
# Table name: audio_variants
#
#  id                  :uuid             not null, primary key
#  format              :string           not null
#  bit_rate            :integer          default(0), not null
#  digital_remaster_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
