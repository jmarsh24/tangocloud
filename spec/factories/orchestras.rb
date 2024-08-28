FactoryBot.define do
  factory :orchestra do
    sequence(:name) { |n| Faker::Lorem.word + n.to_s }
    sort_name { name.split.last }

    after(:build) do |orchestra|
      orchestra.image.attach(io: File.open(Rails.root.join("spec/support/assets/orchestra.jpg")), filename: "orchestra.jpg", content_type: "image/jpg")
    end
  end
end

# == Schema Information
#
# Table name: orchestras
#
#  id                     :uuid             not null, primary key
#  name                   :string           not null
#  sort_name              :string
#  path                   :path             not null
#  normalized_name        :string           default(""), not null
#  el_recodo_orchestra_id :uuid
#  slug                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
