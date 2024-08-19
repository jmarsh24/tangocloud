class WaveformDatum < ApplicationRecord
  has_many :waveforms, dependent: :nullify
end

# == Schema Information
#
# Table name: waveform_data
#
#  id         :uuid             not null, primary key
#  data       :float            default([]), not null, is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
