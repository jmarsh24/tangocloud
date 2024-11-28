FactoryBot.define do
  factory :person do
    name { Faker::Name.name }
    birth_date { Faker::Date.between(from: "1850-01-01", to: "1950-12-31") }
    death_date { Faker::Date.between(from: "1900-01-01", to: "2000-12-31") }

    after(:build) do |person|
      person.image.attach(io: File.open(Rails.root.join("spec/support/assets/orchestra.jpg")), filename: "orchestra.jpg", content_type: "image/jpg")
    end

    trait :composer do
      after(:create) do |person|
        create(:composition_role, person:, role: "composer")
      end
    end

    trait :lyricist do
      after(:create) do |person|
        create(:composition_role, person:, role: "lyricist")
      end
    end

    trait :singer do
      after(:create) do |person|
        create(:orchestra_role, person:, role: create(:role, name: "singer"))
      end
    end
  end
end

# == Schema Information
#
# Table name: people
#
#  id                  :uuid             not null, primary key
#  name                :string           default(""), not null
#  slug                :string
#  sort_name           :string
#  nickname            :string
#  birth_place         :string
#  normalized_name     :string           default(""), not null
#  pseudonym           :string
#  bio                 :text
#  birth_date          :date
#  death_date          :date
#  el_recodo_person_id :uuid
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  display_name        :string
#  recordings_count    :integer          default(0), not null
#
