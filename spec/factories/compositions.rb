FactoryBot.define do
  factory :composition do
    title { Faker::Music.unique.album }

    after(:create) do |composition|
      create(:composition_role, composition:, person: create(:person), role: "composer")
      create(:composition_role, composition:, person: create(:person), role: "lyricist")
    end
  end
end

# == Schema Information
#
# Table name: compositions
#
#  id         :uuid             not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
