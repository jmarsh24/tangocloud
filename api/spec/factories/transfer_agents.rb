FactoryBot.define do
  factory :transfer_agent do
    name { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    url { Faker::Internet.url }

    after(:build) do |transfer_agent|
      transfer_agent.image.attach(
        io: File.open(Rails.root.join("spec/support/assets/orchestra.jpg")),
        filename: "orchestra.jpg",
        content_type: "image/jpg"
      )
      transfer_agent.logo.attach(
        io: File.open(Rails.root.join("spec/support/assets/orchestra.jpg")),
        filename: "orchestra.jpg",
        content_type: "image/jpg"
      )
    end
  end
end

# == Schema Information
#
# Table name: transfer_agents
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
