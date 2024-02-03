require "rails_helper"

RSpec.describe TandaRecording, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: tanda_recordings
#
#  id           :uuid             not null, primary key
#  position     :integer          default(0), not null
#  tanda_id     :uuid             not null
#  recording_id :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
