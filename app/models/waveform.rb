class Waveform < ApplicationRecord
  belongs_to :digital_remaster

  has_one_attached :image

  def export_filename
    "#{digital_remaster.recording.title.parameterize}_#{digital_remaster.id}"
  end
end

# == Schema Information
#
# Table name: waveforms
#
#  id                  :uuid             not null, primary key
#  version             :integer          not null
#  channels            :integer          not null
#  sample_rate         :integer          not null
#  samples_per_pixel   :integer          not null
#  bits                :integer          not null
#  length              :integer          not null
#  data                :float            default([]), is an Array
#  digital_remaster_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
