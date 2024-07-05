# == Schema Information
#
# Table name: audio_transfers
#
#  id                :uuid             not null, primary key
#  external_id       :string
#  album_id          :uuid             not null
#  transfer_agent_id :uuid
#  recording_id      :uuid             not null
#  audio_file_id     :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryBot.define do
  factory :audio_transfer do
    external_id { "ERT-1" }
    association :album
    association :transfer_agent
    association :recording
    association :audio_file

    trait :with_flac_file do
      after(:build) do |audio_transfer|
        audio_transfer.audio_file = build(:flac_audio_file, audio_transfer: audio_transfer)
      end
    end

    trait :with_mp3_file do
      after(:build) do |audio_transfer|
        audio_transfer.audio_file = build(:mp3_audio_file, audio_transfer: audio_transfer)
      end
    end

    factory :flac_audio_transfer, traits: [:with_flac_file]
    factory :mp3_audio_transfer, traits: [:with_mp3_file]
  end
end
