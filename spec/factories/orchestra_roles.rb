FactoryBot.define do
  factory :orchestra_role do
    name { "MyString" }
  end
end

# == Schema Information
#
# Table name: orchestra_roles
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
