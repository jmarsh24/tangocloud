# == Schema Information
#
# Table name: digital_remasters
#
#  id                :uuid             not null, primary key
#  duration          :integer          default(0), not null
#  bpm               :integer
#  external_id       :string
#  replay_gain       :float
#  tango_cloud_id    :integer          not null
#  album_id          :uuid             not null
#  remaster_agent_id :uuid
#  recording_id      :uuid             not null
#  audio_file_id     :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryBot.define do
  factory :digital_remaster do
    external_id { "ERT-1" }
    duration { 180 }
    association :album
    association :transfer_agent
    association :recording
    association :audio_file

    trait :with_flac_file do
      after(:build) do |digital_remaster|
        digital_remaster.audio_file = build(:flac_audio_file, digital_remaster:)
      end
    end

    trait :with_mp3_file do
      after(:build) do |digital_remaster|
        digital_remaster.audio_file = build(:mp3_audio_file, digital_remaster:)
      end
    end

    factory :flac_digital_remaster, traits: [:with_flac_file]
    factory :mp3_digital_remaster, traits: [:with_mp3_file]
  end
end
