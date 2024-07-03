FactoryBot.define do
  factory :transfer_agent do
    name { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    url { Faker::Internet.url }

    after(:build) do |transfer_agent|
      transfer_agent.image.attach(
        io: File.open(Rails.root.join("spec/support/assets/transfer_agent_image.png")),
        filename: "transfer_agent_image.png",
        content_type: "image/png"
      )
      transfer_agent.logo.attach(
        io: File.open(Rails.root.join("spec/support/assets/transfer_agent_logo.png")),
        filename: "transfer_agent_logo.png",
        content_type: "image/png"
      )
    end
  end
end
