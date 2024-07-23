class RecordingSinger < ApplicationRecord
  belongs_to :recording
  belongs_to :person
end

# == Schema Information
#
# Table name: recording_singers
#
#  id           :uuid             not null, primary key
#  recording_id :uuid             not null
#  person_id    :uuid             not null
#  soloist      :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
