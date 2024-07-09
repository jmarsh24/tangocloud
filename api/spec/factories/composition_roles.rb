FactoryBot.define do
  factory :composition_role do
    role { "composer" }
    association :person
    association :composition
  end
end
