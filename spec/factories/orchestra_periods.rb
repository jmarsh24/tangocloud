# == Schema Information
#
# Table name: orchestra_periods
#
#  id           :integer          not null, primary key
#  name         :string
#  description  :text
#  start_date   :date
#  end_date     :date
#  orchestra_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :orchestra_period do
    name { "MyString" }
    description { "MyText" }
    start_date { Faker::Date.between(from: "1930-01-01", to: "1950-12-31") }
    end_date { Faker::Date.between(from: "1960-01-01", to: "1980-12-31") }
    orchestra
  end
end
