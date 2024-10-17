FactoryBot.define do
  factory :waveform do
    version { Faker::Number.between(from: 1, to: 3) }
    channels { Faker::Number.between(from: 1, to: 2) }
    sample_rate { Faker::Number.between(from: 22050, to: 48000) }
    samples_per_pixel { Faker::Number.between(from: 100, to: 1000) }
    bits { Faker::Number.between(from: 8, to: 32) }
    length { Faker::Number.between(from: 60, to: 3600) }
    association :digital_remaster
    association :waveform_datum

    after(:build) do |waveform|
      waveform.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/19401008_volver_a_sonar_roberto_rufino_tango_2476_waveform.png")),
        filename: "19401008_volver_a_sonar_roberto_rufino_tango_2476_waveform.png",
        content_type: "image/png"
      )
    end
  end
end

# == Schema Information
#
# Table name: waveforms
#
#  id                  :integer          not null, primary key
#  version             :integer          not null
#  channels            :integer          not null
#  sample_rate         :integer          not null
#  samples_per_pixel   :integer          not null
#  bits                :integer          not null
#  length              :integer          not null
#  digital_remaster_id :integer          not null
#  waveform_datum_id   :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
