FactoryBot.define do
  factory :composition do
    title { Faker::Music.album }
    association :lyricist, factory: :lyricist
    association :composer, factory: :composer
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
