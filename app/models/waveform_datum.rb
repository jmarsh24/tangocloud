class WaveformDatum < ApplicationRecord
  has_many :waveforms, dependent: :nullify
end

# == Schema Information
#
# Table name: waveform_data
#
#  id         :integer          not null, primary key
#  data       :text             default(""), not null
#  text       :text             default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
