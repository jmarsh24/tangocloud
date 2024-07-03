FactoryBot.define do
  factory :user_preference do
    association :user
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    after(:build) do |user_preference|
      user_preference.avatar.attach(io: File.open(Rails.root.join("spec/support/assets/avatar.jpg")), filename: "avatar.jpg", content_type: "image/jpg")
    end
  end
end
