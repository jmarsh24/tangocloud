# == Schema Information
#
# Table name: orchestra_periods
#
#  id           :uuid             not null, primary key
#  name         :string
#  description  :text
#  start_date   :date
#  end_date     :date
#  orchestra_id :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :orchestra_period do
    name { "MyString" }
    description { "MyText" }
    start_date { "2024-07-07" }
    end_date { "2024-07-07" }
    orchestra { nil }
  end
end
