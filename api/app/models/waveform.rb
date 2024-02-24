class Waveform < ApplicationRecord
  belongs_to :audio_transfer

  has_one_attached :image
end

# == Schema Information
#
# Table name: waveforms
#
#  id                :uuid             not null, primary key
#  audio_transfer_id :uuid             not null
#  version           :integer          not null
#  channels          :integer          not null
#  sample_rate       :integer          not null
#  samples_per_pixel :integer          not null
#  bits              :integer          not null
#  length            :integer          not null
#  data              :float            default([]), is an Array
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
