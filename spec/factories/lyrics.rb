FactoryBot.define do
  factory :lyric do
    locale { "en" }
    content { Faker::Lorem.paragraph }
    association :composition
  end
end

# == Schema Information
#
# Table name: lyrics
#
#  id             :uuid             not null, primary key
#  text           :text             not null
#  composition_id :uuid             not null
#  language_id    :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
