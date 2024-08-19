FactoryBot.define do
  factory :waveform_datum do
    data { Array.new(100) { Faker::Number.decimal(l_digits: 3, r_digits: 3) } }
  end
end

# == Schema Information
#
# Table name: waveform_data
#
#  id         :uuid             not null, primary key
#  data       :float            default([]), not null, is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
