class TandaRecording < ApplicationRecord
  include RankedModel

  belongs_to :tanda, counter_cache: :recordings_count
  belongs_to :recording, counter_cache: :tandas_count

  ranks :position, with_same: :tanda_id
end

# == Schema Information
#
# Table name: tanda_recordings
#
#  id           :uuid             not null, primary key
#  tanda_id     :uuid             not null
#  recording_id :uuid             not null
#  position     :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
