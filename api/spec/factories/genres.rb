FactoryBot.define do
  factory :genre do
    name { Faker::Music.genre }
    description { Faker::Lorem.sentence }
  end
end

# == Schema Information
#
# Table name: genres
#
#  id               :uuid             not null, primary key
#  name             :string           not null
#  description      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recordings_count :integer          default(0)
#
