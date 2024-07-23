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

# == Schema Information
#
# Table name: likes
#
#  id            :uuid             not null, primary key
#  likeable_type :string           not null
#  likeable_id   :uuid             not null
#  user_id       :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
