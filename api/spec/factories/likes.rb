FactoryBot.define do
  factory :like do
    association :user
    association :likeable, factory: :recording

    trait :for_recording do
      association :likeable, factory: :recording
    end

    trait :for_playlist do
      association :likeable, factory: :playlist
    end

    trait :for_composition do
      association :likeable, factory: :composition
    end
  end
end
