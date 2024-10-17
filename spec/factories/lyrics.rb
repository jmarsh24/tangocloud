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
#  id          :integer          not null, primary key
#  text        :text             not null
#  language_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
