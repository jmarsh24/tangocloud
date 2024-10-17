FactoryBot.define do
  factory :composition_role do
    role { "composer" }
    association :person
    association :composition
  end
end

# == Schema Information
#
# Table name: composition_roles
#
#  id             :integer          not null, primary key
#  role           :composition_role not null
#  person_id      :integer          not null
#  composition_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
