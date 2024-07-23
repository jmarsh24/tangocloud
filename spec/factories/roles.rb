FactoryBot.define do
  factory :role do
    name { "singer" }
  end
end

# == Schema Information
#
# Table name: roles
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
