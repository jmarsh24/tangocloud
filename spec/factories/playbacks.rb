FactoryBot.define do
  factory :playback do
    association :recording
    association :user
  end
end

# == Schema Information
#
# Table name: playbacks
#
#  id           :integer          not null, primary key
#  duration     :integer          default(0), not null
#  user_id      :integer          not null
#  recording_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
