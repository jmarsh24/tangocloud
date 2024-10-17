FactoryBot.define do
  factory :time_period do
    name { Faker::Music.unique.genre }
    description { Faker::Lorem.paragraph }
    start_year { Faker::Number.between(from: 1900, to: 1950) }
    end_year { Faker::Number.between(from: 1951, to: 2000) }

    after(:build) do |time_period|
      time_period.image.attach(io: File.open(Rails.root.join("spec/support/assets/orchestra.jpg")), filename: "orchestra.jpg", content_type: "image/jpg")
    end
  end
end

# == Schema Information
#
# Table name: time_periods
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  start_year  :integer          default(0), not null
#  end_year    :integer          default(0), not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
