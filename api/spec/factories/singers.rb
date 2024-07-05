FactoryBot.define do
  factory :singer do
    name { Faker::Name.name }
    slug { Faker::Internet.slug(words: name, glue: "-") }
    rank { Faker::Number.between(from: 0, to: 100) }
    soloist { [true, false].sample }
    bio { Faker::Lorem.paragraph }
    birth_date { Faker::Date.between(from: "1900-01-01", to: "2000-12-31") }
    death_date { Faker::Date.between(from: "2000-01-01", to: "2020-12-31") }

    after(:build) do |singer|
      singer.photo.attach(
        io: File.open(Rails.root.join("spec/support/assets/orchestra.jpg")),
        filename: "orchestra.jpg",
        content_type: "image/jpg"
      )
    end

    trait :reindex do
      after(:create) do |singer, _evaluator|
        singer.reindex(refresh: true)
      end
    end
  end
end

# == Schema Information
#
# Table name: singers
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  rank       :integer          default(0), not null
#  soloist    :boolean          default(FALSE), not null
#  sort_name  :string
#  bio        :text
#  birth_date :date
#  death_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
