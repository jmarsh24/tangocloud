FactoryBot.define do
  factory :genre do
    name { Faker::Music.unique.genre }
  end
end

# == Schema Information
#
# Table name: genres
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
