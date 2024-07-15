FactoryBot.define do
  factory :remaster_agent do
    name { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    url { Faker::Internet.url }
  end
end

# == Schema Information
#
# Table name: remaster_agents
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :text
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
