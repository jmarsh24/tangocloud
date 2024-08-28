class Waveform < ApplicationRecord
  belongs_to :digital_remaster
  belongs_to :waveform_datum, optional: true, dependent: :destroy
  has_one_attached :image

  delegate :data, :data=, to: :waveform_datum

  before_save :ensure_waveform_datum

  def export_filename
    "#{digital_remaster.recording.title.parameterize}_#{digital_remaster.id}"
  end

  private

  def ensure_waveform_datum
    self.waveform_datum ||= WaveformDatum.new
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
#  digital_remaster_id :uuid             not null
#  waveform_datum_id   :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
