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
#  id             :uuid             not null, primary key
#  role           :enum             not null
#  person_id      :uuid             not null
#  composition_id :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
