FactoryBot.define do
  factory :orchestra_role do
    start_date { Faker::Date.between(from: "1930-01-01", to: "1950-12-31") }
    end_date { Faker::Date.between(from: "1960-01-01", to: "1980-12-31") }
    principal { false }
    association :orchestra
    association :role
    association :person
  end
end
