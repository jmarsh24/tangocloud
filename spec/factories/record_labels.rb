FactoryBot.define do
  factory :record_label do
    name { Faker::Music.unique.band }
    description { Faker::Lorem.paragraph }
    founded_date { Faker::Date.between(from: "1900-01-01", to: "2020-12-31") }
  end
end

# == Schema Information
#
# Table name: record_labels
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  description  :text
#  founded_date :date
#  bio          :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
