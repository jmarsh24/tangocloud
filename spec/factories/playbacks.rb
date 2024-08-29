FactoryBot.define do
  factory :playback do
    association :recording
    association :user
  end
end
